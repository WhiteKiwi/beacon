import { NestFactory } from '@nestjs/core';
import { DocumentBuilder, SwaggerModule } from '@nestjs/swagger';
import { AppModule } from './app.module.js';
import { validationPipe } from './validation.pipe.js';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  app.useGlobalPipes(validationPipe);

  if (process.env.ENV !== 'live') {
    const config = new DocumentBuilder()
      .setTitle('Beacon')
      .setDescription('위치 데이터 수신 및 조회 API')
      .setVersion('1.0')
      .addBearerAuth()
      .build();
    SwaggerModule.setup('api-docs', app, SwaggerModule.createDocument(app, config));
  }

  await app.listen(process.env.PORT ?? 3000);
}
bootstrap();
