import { NestFactory } from '@nestjs/core';
import { ExpressAdapter } from '@nestjs/platform-express';
import { AppModule } from './app/app.module';
import express from 'express';
import { onRequest } from 'firebase-functions/v2/https';
import { GlobalExceptionFilter } from './common/filters/http-exception.filter';

const expressServer = express();

const createFunction = async (expressInstance) => {
  const app = await NestFactory.create(
    AppModule,
    new ExpressAdapter(expressInstance),
    { 
      bodyParser: false 
    }
  );
  app.useGlobalFilters(new GlobalExceptionFilter());

  app.use((req, res, next) => {
    if (req.path.includes('/menu/scan')) {
      console.log(`[DEBUG] POST /scan hit. Content-Type: ${req.headers['content-type']}`);
    }
    next();
  });
  
  app.setGlobalPrefix('api');
  
  app.enableCors();
  await app.init();
};

createFunction(expressServer);

export const api = onRequest(
  { 
    secrets: ['OPENAI_API_KEY'],
    cors: true,
    memory: '1GiB',
    timeoutSeconds: 300,
  }, 
  expressServer
);