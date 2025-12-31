import { PipeTransform, ArgumentMetadata, BadRequestException, Logger } from '@nestjs/common';
import { ZodSchema } from 'zod';

export class ZodValidationPipe implements PipeTransform {
  private readonly logger = new Logger(ZodValidationPipe.name);

  constructor(private schema: ZodSchema) {}

  transform(value: unknown, metadata: ArgumentMetadata) {
    // Skip validation if value is not an object/array (e.g. file uploads handled separately)
    if (metadata.type !== 'body') return value;

    this.logger.debug(`Validating request body against schema`);
    const result = this.schema.safeParse(value);
    
    if (!result.success) {
      this.logger.warn('Validation failed', {
        errors: result.error.issues,
        receivedValue: JSON.stringify(value).substring(0, 200),
      });
      throw new BadRequestException({
        message: 'Validation failed',
        errors: result.error.flatten(),
      });
    }
    
    this.logger.debug('Validation passed successfully');
    return result.data;
  }
}