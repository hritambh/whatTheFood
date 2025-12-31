import { z } from 'zod';

// Define the Schema
export const MenuItemSchema = z.object({
  name: z.string().min(1, "Name is required"),
  // CHANGED: .optional() -> .nullish() to allow nulls coming from Flutter
  price: z.string().nullish().describe("Price as a string, e.g., '$10.50'"),
  description: z.string().nullish().describe("Short description of the dish"),
  category: z.string().nullish().describe("e.g., Starters, Mains, Drinks"),
});

// Infer TypeScript Type
export type MenuItemDto = z.infer<typeof MenuItemSchema>;