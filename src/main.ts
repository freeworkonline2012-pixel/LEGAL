import { ValidationPipe } from '@nestjs/common';
import { NestFactory } from '@nestjs/core';
import { NestExpressApplication } from '@nestjs/platform-express';
import { DocumentBuilder, SwaggerModule } from '@nestjs/swagger';
import helmet from 'helmet';
import { AppModule } from './app.module';

async function bootstrap(): Promise<void> {
  const app = await NestFactory.create<NestExpressApplication>(AppModule);
  const isProduction = process.env.NODE_ENV === 'production';

  app.setGlobalPrefix('api');
  app.enableShutdownHooks();

  // ثقة في وسيط Railway الأمامي (Edge Proxy): بدون هذا، Express/Throttler يرى كل الطلبات
  // كأنها قادمة من نفس عنوان IP الداخلي لـ Railway، فيعطّل حد المعدل (Rate Limiting) فعلياً
  // ويُفسد أي منطق يعتمد على req.ip. القيمة 1 تعني "ثق بأول وسيط أمامي فقط" (وهو ما يطابق
  // بنية Railway - طبقة وسيطة واحدة بين العميل والحاوية) بدلاً من `true` التي تثق بالسلسلة كاملة.
  app.set('trust proxy', 1);

  // H-1/EP-09: رؤوس أمان HTTP (helmet) — تُفعَّل في كل البيئات (ملاحظة مراجعة جولة 15).
  app.use(helmet());

  const corsOrigins: string[] = process.env.CORS_ORIGIN?.split(',').map((origin: string) =>
    origin.trim(),
  ) ?? ['http://localhost:3000'];

  app.enableCors({
    origin: corsOrigins,
    credentials: true,
  });

  app.useGlobalPipes(
    new ValidationPipe({
      whitelist: true,
      forbidNonWhitelisted: true,
      transform: true,
      transformOptions: { enableImplicitConversion: true },
    }),
  );

  // توثيق Swagger/OpenAPI — مرآة لعقد backend/openapi.yaml.
  // يُكشف في غير الإنتاج فقط (ملاحظة مراجعة جولة 15): في الإنتاج العقد الرسمي
  // متاح عبر backend/openapi.yaml ومرآة CI، ولا داعي لكشف واجهة استكشافية عامة.
  if (!isProduction) {
    const swaggerConfig = new DocumentBuilder()
      .setTitle('منصة قانونية عربية — API')
      .setDescription(
        'Grounded Legal RAG — العقد الرسمي موثّق في backend/openapi.yaml وهو مصدر الحقيقة',
      )
      .setVersion('0.1.0')
      .addBearerAuth()
      .build();
    const document = SwaggerModule.createDocument(app, swaggerConfig);
    SwaggerModule.setup('api/docs', app, document);
  }

  const port = Number(process.env.PORT ?? 3001);
  await app.listen(port);
}

void bootstrap();
