import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Law } from '../database/entities/law.entity';
import { LawsController } from './laws.controller';
import { LawsService } from './laws.service';

@Module({
  imports: [TypeOrmModule.forFeature([Law])],
  controllers: [LawsController],
  providers: [LawsService],
  exports: [LawsService],
})
export class LawsModule {}
