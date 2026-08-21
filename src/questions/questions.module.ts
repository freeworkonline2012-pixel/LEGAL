import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { AuditModule } from '../audit/audit.module';
import { Answer } from '../database/entities/answer.entity';
import { Citation } from '../database/entities/citation.entity';
import { Feedback } from '../database/entities/feedback.entity';
import { Question } from '../database/entities/question.entity';
import { QuestionsController } from './questions.controller';
import { QuestionsService } from './questions.service';

@Module({
  imports: [
    // forFeature تُسجّل metadata الكيانات حتى يعمل dataSource.getRepository(...)
    TypeOrmModule.forFeature([Question, Answer, Citation, Feedback]),
    AuditModule,
  ],
  controllers: [QuestionsController],
  providers: [QuestionsService],
  exports: [QuestionsService],
})
export class QuestionsModule {}
