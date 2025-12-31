import { NestFactory } from '@nestjs/core';
import { Logger } from '@nestjs/common';
import { AppModule } from './app/app.module';
import { GlobalExceptionFilter } from './common/filters/http-exception.filter';

async function bootstrap() {
  const logger = new Logger('Bootstrap');
  
  logger.log('Starting application...');
  const app = await NestFactory.create(AppModule, {
    logger: ['error', 'warn', 'log', 'debug', 'verbose'],
  });
  
  // 1. ADD THIS LINE
  app.enableCors(); 

  app.setGlobalPrefix('api');
  logger.log('Global API prefix set to: /api');
  
  app.useGlobalFilters(new GlobalExceptionFilter());
  logger.log('Global exception filter registered');
  
  const port = process.env.PORT || 3000;
  await app.listen(port);
  
  logger.log(`🚀 Application is running on: http://localhost:${port}/api`);
  logger.log(`Environment: ${process.env.NODE_ENV || 'development'}`);
}
bootstrap();