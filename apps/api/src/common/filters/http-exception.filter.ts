import { ExceptionFilter, Catch, ArgumentsHost, HttpException, HttpStatus, Logger } from '@nestjs/common';
import { Response } from 'express';

@Catch()
export class GlobalExceptionFilter implements ExceptionFilter {
  private readonly logger = new Logger(GlobalExceptionFilter.name);

  catch(exception: unknown, host: ArgumentsHost) {
    const ctx = host.switchToHttp();
    const request = ctx.getRequest();
    const response = ctx.getResponse<Response>();
    
    let status = HttpStatus.INTERNAL_SERVER_ERROR;
    let message = 'Internal server error';
    let details = null;

    if (exception instanceof HttpException) {
      status = exception.getStatus();
      const res = exception.getResponse() as { message?: string | string[]; errors?: unknown };
      message = Array.isArray(res.message) ? res.message.join(', ') : (res.message || exception.message);
      details = res.errors || null; // Capture Zod errors if present
      
      // Log HTTP exceptions with context
      this.logger.warn(`HTTP ${status} - ${request.method} ${request.url}`, {
        statusCode: status,
        message,
        details,
        path: request.url,
        method: request.method,
      });
    } else {
      // Log unknown critical errors with full context
      this.logger.error('Unhandled Exception', {
        error: exception instanceof Error ? exception.message : String(exception),
        stack: exception instanceof Error ? exception.stack : undefined,
        path: request.url,
        method: request.method,
        body: request.body,
        query: request.query,
      });
    }

    response.status(status).json({
      statusCode: status,
      timestamp: new Date().toISOString(),
      message,
      details,
    });
  }
}