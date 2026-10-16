import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { LegalReference } from '../database/entities/legal-reference.entity';
import { LegalReferenceSection } from '../database/entities/legal-reference-section.entity';
import { LegalReferencesController } from './legal-references.controller';
import { LegalReferencesService } from './legal-references.service';

@Module({
  imports: [TypeOrmModule.forFeature([LegalReference, LegalReferenceSection])],
  controllers: [LegalReferencesController],
  providers: [LegalReferencesService],
  exports: [LegalReferencesService],
})
export class LegalReferencesModule {}
