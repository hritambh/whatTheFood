import { z } from 'zod';
import { MenuItemSchema } from './menu-item.dto';

// AI often wraps arrays in an object, we force this structure for reliability
export const ScanResponseSchema = z.object({
  items: z.array(MenuItemSchema),
});

export type ScanResponseDto = z.infer<typeof ScanResponseSchema>;