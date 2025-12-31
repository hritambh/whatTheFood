import { 
  Injectable, 
  InternalServerErrorException, 
  Logger 
} from '@nestjs/common';
import OpenAI from 'openai';
import axios from 'axios';
import { MenuItemDto } from './dto/menu-item.dto';
import { EnrichedItemDto, EnrichedItemSchema } from './dto/enriched-item.dto';
import { ScanResponseSchema } from './dto/scan-response.dto';

@Injectable()
export class OpenAIService {
  private readonly openai: OpenAI;
  private readonly logger = new Logger(OpenAIService.name);

  constructor() {
    if (!process.env.OPENAI_API_KEY) {
      this.logger.error('OPENAI_API_KEY environment variable is missing');
      throw new InternalServerErrorException('OPENAI_API_KEY is missing');
    }
    this.logger.log('OpenAI service initialized successfully');
    this.openai = new OpenAI({ apiKey: process.env.OPENAI_API_KEY });
  }

  /**
   * Uploads the image buffer to OpenAI Files API.
   * Returns the file ID (e.g., "file-abc123xyz").
   */
  private async uploadImageFile(imageBuffer: Buffer): Promise<string> {
    this.logger.log(`Starting image upload to OpenAI (${imageBuffer.length} bytes)...`);
    const startTime = Date.now();

    try {
      // FIX: Convert Buffer to Uint8Array. 
      // This resolves the "Type 'Buffer' is not assignable to 'BlobPart'" error 
      // because Uint8Array is a standard Web API type compatible with Blob.
      const blob = new Blob([new Uint8Array(imageBuffer)], { type: 'image/jpeg' });
      
      const formData = new FormData();
      formData.append('purpose', 'vision');
      formData.append('file', blob, 'menu-scan.jpg');

      const response = await axios.post('https://api.openai.com/v1/files', formData, {
        headers: {
          'Authorization': `Bearer ${process.env.OPENAI_API_KEY}`,
          // Note: When using native FormData in Node 20+, Axios/Fetch automatically sets the correct boundary.
        },
      });

      const duration = Date.now() - startTime;
      const fileId = response.data.id;
      this.logger.log(`Image uploaded successfully. File ID: ${fileId} (${duration}ms)`);
      return fileId;
    } catch (error) {
      this.logger.error('Failed to upload file to OpenAI', error instanceof Error ? error.message : error);
      // Log detailed axios error if available
      if (axios.isAxiosError(error)) {
        this.logger.error('Upload Axios Error Details:', error.response?.data);
      }
      throw new InternalServerErrorException('Failed to upload image for processing');
    }
  }

  /**
   * Extracts menu items from an image using the Custom Responses API flow.
   */
  async extractFromImage(imageBuffer: Buffer): Promise<MenuItemDto[]> {
    const startTime = Date.now();
    const imageSizeKB = Math.round(imageBuffer.length / 1024);
    this.logger.log(`Starting menu extraction process for image (${imageSizeKB}KB)`);

    let fileId: string;

    // STEP 1: UPLOAD
    try {
      fileId = await this.uploadImageFile(imageBuffer);
    } catch (e) {
      // Already logged in uploadImageFile
      throw e; 
    }

    // STEP 2: GENERATE RESPONSE
    try {
      this.logger.log(`[Step 2] Preparing to call Responses API with File ID: ${fileId}`);
      
      const promptText = `
You are an OCR extractor.

Task:
Extract sellable item names and descriptions visible in the image.

Rules:
- Output ONLY valid JSON
- Do NOT include section headers
- Do NOT include prices
- Do NOT infer missing items
- Do NOT include duplicates

Schema:
{
  "items": [
    { 
      "name": "string",
      "description": "string (optional)"
    }
  ]
}

If no items are found, return:
{ "items": [] }
`;

      const requestBody = {
        model: 'gpt-4.1-mini', 
        input: [
          {
            role: 'user',
            content: [
              { type: 'input_text', text: promptText },
              { type: 'input_image', file_id: fileId }
            ]
          }
        ]
      };

      const apiStartTime = Date.now();
      this.logger.debug(`Sending request to https://api.openai.com/v1/responses...`);

      const response = await axios.post('https://api.openai.com/v1/responses', requestBody, {
        headers: {
          'Authorization': `Bearer ${process.env.OPENAI_API_KEY}`,
          'Content-Type': 'application/json'
        }
      });

      const apiDuration = Date.now() - apiStartTime;
      this.logger.log(`Responses API responded in ${apiDuration}ms with status: ${response.status}`);

      // STEP 3: PARSE RESPONSE
      const outputMessage = response.data.output?.[0];
      
      if (!outputMessage || outputMessage.status !== 'completed') {
        this.logger.error('Responses API returned incomplete status', { 
          status: outputMessage?.status,
          fullResponse: JSON.stringify(response.data).substring(0, 1000) 
        });
        throw new Error(`Invalid response status: ${outputMessage?.status}`);
      }

      const rawContent = outputMessage.content?.[0]?.text;
      
      if (!rawContent) {
        this.logger.error('Responses API returned empty content field');
        throw new Error('Empty content from AI Service');
      }

      this.logger.debug(`Received Raw Content (Length: ${rawContent.length}): \n${rawContent.substring(0, 300)}...`);

      // STEP 4: JSON PARSE
      let parsedJson;
      try {
        const cleanContent = rawContent.replace(/```json\n?|\n?```/g, '').trim();
        parsedJson = JSON.parse(cleanContent);
      } catch (parseError) {
        this.logger.error(`Failed to parse JSON content. Raw content was: ${rawContent}`);
        throw new InternalServerErrorException('AI response was not valid JSON');
      }

      // STEP 5: MAPPING & VALIDATION
      if (!parsedJson.items || !Array.isArray(parsedJson.items)) {
         this.logger.error('Invalid JSON structure: missing "items" array', parsedJson);
         throw new InternalServerErrorException('AI response invalid structure');
      }

      const mappedItems = parsedJson.items.map((item: any) => ({
        name: item.name,
        description: item.description || undefined,
        price: undefined,
        category: undefined
      }));

      this.logger.debug(`Mapped ${mappedItems.length} items. Validating with Zod...`);

      const result = ScanResponseSchema.safeParse({ items: mappedItems });

      if (!result.success) {
        this.logger.error('Zod Schema Validation Failed', {
          errors: result.error.issues,
          dataSample: JSON.stringify(mappedItems).substring(0, 500)
        });
        throw new InternalServerErrorException('Extracted data did not match schema');
      }

      const totalDuration = Date.now() - startTime;
      this.logger.log(`SUCCESS: Extracted ${result.data.items.length} items in ${totalDuration}ms`);
      
      return result.data.items;

    } catch (error) {
      const totalDuration = Date.now() - startTime;
      
      if (axios.isAxiosError(error)) {
        this.logger.error(`Responses API Request Failed (Status: ${error.response?.status})`, {
          data: error.response?.data,
          message: error.message
        });
      } else {
        this.logger.error(`Menu extraction failed after ${totalDuration}ms`, {
          error: error instanceof Error ? error.message : String(error),
          stack: error instanceof Error ? error.stack : undefined,
        });
      }

      // Re-throw appropriate exceptions
      if (error instanceof InternalServerErrorException) throw error;
      throw new InternalServerErrorException('Failed to process menu image');
    }
  }

  // ... (enrichItem method remains unchanged)
  async enrichItem(item: MenuItemDto): Promise<EnrichedItemDto> {
    const startTime = Date.now();
    this.logger.log(`Starting enrichment for item: "${item.name}"`);

    try {
      // Use Promise.all to run both AI tasks in parallel
      const [textResponse, imageResponse] = await Promise.all([
        // 1. Text Enrichment
        this.openai.chat.completions.create({
          model: 'gpt-4o',
          response_format: { type: 'json_object' },
          messages: [
            {
              role: 'system',
              content: `You are a food safety expert. Analyze the menu item.
              Infer ingredients, allergens, and dietary type.
              
              Return strict JSON:
              {
                "ingredients": ["string"],
                "allergens": ["string"],
                "dietaryType": "VEGAN" | "VEG" | "NON_VEG",
                "aiDescription": "string (2-3 sentences explaining the dish)"
              }

              Rules:
              1. dietaryType MUST be "VEGAN", "VEG", or "NON_VEG".
              2. If allergens are ambiguous, list potential ones.
              3. Never hallucinate ingredients.`,
            },
            {
              role: 'user',
              content: JSON.stringify(item),
            },
          ],
          temperature: 0.1,
        }),

        // 2. Image Generation (with explicit logging)
        (async () => {
          this.logger.log(`[Image Gen] Requesting DALL-E 3 image for "${item.name}"...`); 
          try {
            const res = await this.openai.images.generate({
              model: 'dall-e-3',
              // CHANGE: Updated prompt for realism
              prompt: `A photorealistic, high-resolution, top-down food photograph of ${item.name} (Indian cuisine). 
              The image should look like it was taken in a restaurant with natural window lighting, not artificial studio lights. 
              Focus on realistic food textures, authentic plating, and appetizing natural colors. 
              Avoid plastic-looking surfaces, 3D render styles, or cartoonish exaggerations.`,
              n: 1,
              size: '1024x1024',
              response_format: 'b64_json',
            });
            const b64 = res.data[0]?.b64_json;
            if (b64) {
              this.logger.log(`[Image Gen] SUCCESS. Base64 generated for "${item.name}"`);
              return `data:image/png;base64,${b64}`;
            }
            return null;
          } catch (err) {
            this.logger.error(`[Image Gen] FAILED for "${item.name}": ${err.message}`);
            return null; // Return null so the rest of the flow doesn't crash
          }
        })(),
      ]);

      const apiDuration = Date.now() - startTime;
      this.logger.log(`All AI Tasks completed in ${apiDuration}ms`);

      // Process Text
      const rawContent = textResponse.choices[0].message.content;
      if (!rawContent) throw new Error('Empty enrichment text response');
      const parsedJson = JSON.parse(rawContent);

      // Merge Data (including the image URL from the parallel task)
      const mergedData = { 
        ...item, 
        ...parsedJson,
        imageUrl: imageResponse // <--- Add the image URL here
      };
      
      const result = EnrichedItemSchema.safeParse(mergedData);

      if (!result.success) {
        this.logger.error('Enrichment schema validation failed', { errors: result.error.issues });
        throw new InternalServerErrorException('AI enrichment failed validation');
      }

      this.logger.log(`Enrichment complete for "${item.name}" (Includes Image: ${!!imageResponse})`);
      return result.data;

    } catch (error) {
      const totalDuration = Date.now() - startTime;
      this.logger.error(`Item enrichment failed for "${item.name}" after ${totalDuration}ms`, error);
      throw new InternalServerErrorException('Failed to enrich item');
    }
  }
}