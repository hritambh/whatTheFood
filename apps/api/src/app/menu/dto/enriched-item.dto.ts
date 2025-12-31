import { z } from 'zod';
import { MenuItemSchema } from './menu-item.dto';

export const EnrichedItemSchema = MenuItemSchema.extend({
  ingredients: z.array(z.string()).default([]),
  allergens: z.array(z.string()).default([]),
  dietaryType: z.enum(['VEGAN', 'VEG', 'NON_VEG']).default('NON_VEG'),
  // ADD THESE TWO FIELDS:
  aiDescription: z.string().optional().describe("A 2-3 line explanation of the dish"),
  imageUrl: z.string().optional().describe("Generated image URL of the dish"),
});

export type EnrichedItemDto = z.infer<typeof EnrichedItemSchema>;