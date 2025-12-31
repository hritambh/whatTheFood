import { 
  Controller, 
  Post, 
  UseInterceptors, 
  UploadedFile, 
  Body, 
  BadRequestException, 
  UsePipes,
  Logger
} from '@nestjs/common';
import { FileInterceptor } from '@nestjs/platform-express';
import { OpenAIService } from './openai.service';
import { MenuItemDto, MenuItemSchema } from './dto/menu-item.dto';
import { ZodValidationPipe } from '../../common/pipes/zod-validation.pipe';
import 'multer'; // <--- ADD THIS LINE HERE

@Controller('menu')
export class MenuController {
  private readonly logger = new Logger(MenuController.name);

  constructor(private readonly openaiService: OpenAIService) {}

  @Post('scan')
  @UseInterceptors(FileInterceptor('image', {
    limits: { fileSize: 10 * 1024 * 1024 },
    fileFilter: (req, file, cb) => {
      if (!file.mimetype.match(/\/(jpg|jpeg|png|webp)$/)) {
        return cb(new BadRequestException('Only image files are allowed!'), false);
      }
      cb(null, true);
    },
  }))
  // The type 'Express.Multer.File' will now be recognized
  async scanMenu(@UploadedFile() file: Express.Multer.File) {
    const startTime = Date.now();
    this.logger.log('Received menu scan request');

    if (!file) {
      this.logger.warn('Menu scan request rejected: no file provided');
      throw new BadRequestException('Image file is required');
    }

    this.logger.log(`Processing image: ${file.originalname}, size: ${file.size} bytes, mimetype: ${file.mimetype}`);
    
    try {
      const items = await this.openaiService.extractFromImage(file.buffer);
      const duration = Date.now() - startTime;
      this.logger.log(`Menu scan completed successfully: extracted ${items.length} items in ${duration}ms`);
      return { items };
    } catch (error) {
      const duration = Date.now() - startTime;
      this.logger.error(`Menu scan failed after ${duration}ms`, error);
      throw error;
    }
  }

  @Post('enrich')
  @UsePipes(new ZodValidationPipe(MenuItemSchema))
  async enrichMenuItem(@Body() menuItem: MenuItemDto) {
    const startTime = Date.now();
    this.logger.log(`Received enrich request for item: ${menuItem.name || 'unknown'}`);

    try {
      const enriched = await this.openaiService.enrichItem(menuItem);
      const duration = Date.now() - startTime;
      this.logger.log(`Item enrichment completed successfully for "${menuItem.name}" in ${duration}ms`);
      return enriched;
    } catch (error) {
      const duration = Date.now() - startTime;
      this.logger.error(`Item enrichment failed for "${menuItem.name}" after ${duration}ms`, error);
      throw error;
    }
  }
}