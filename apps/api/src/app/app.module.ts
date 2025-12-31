import { Module, NestModule, MiddlewareConsumer, Logger, RequestMethod } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config'; // <--- Import this
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { MenuController } from './menu/menu.controller';
import { OpenAIService } from './menu/openai.service';
import { NextFunction, Request, Response } from 'express';

@Module({
  imports: [
    // Load .env file globally so it's available in all services
    ConfigModule.forRoot({
      isGlobal: true,
    }),
  ],
  controllers: [AppController, MenuController],
  providers: [AppService, OpenAIService],
})
export class AppModule implements NestModule {
  configure(consumer: MiddlewareConsumer) {
    consumer
      .apply((req: Request, res: Response, next: NextFunction) => {
        const logger = new Logger('HTTP');
        logger.log(`Incoming Request: ${req.method} ${req.originalUrl} | IP: ${req.ip}`);
        next();
      })
      .forRoutes({ path: '*', method: RequestMethod.ALL });
  }
}