import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import type { ClauseAssessmentStatus, MatchedArticle } from '../../database/entities/contract-clause.entity';

export class MatchedArticleDto implements MatchedArticle {
  @ApiProperty() law: string;
  @ApiProperty() law_no: number;
  @ApiProperty() law_year: number;
  @ApiProperty() article_no: number;
  @ApiProperty() snippet: string;
  @ApiPropertyOptional({ nullable: true }) official_url: string | null;
}

export class SuggestedRedraftDto {
  @ApiProperty() text: string;
  @ApiProperty({ type: [String] }) changes: string[];
  @ApiProperty() disclaimer: string;
  @ApiProperty() no_change: boolean;
  @ApiPropertyOptional({ nullable: true }) note: string | null;
}

export class RuleFindingDto {
  @ApiProperty() rule_id: string;
  @ApiProperty() topic: string;
  @ApiProperty({ enum: ['compliant', 'review'] }) status: 'compliant' | 'review';
  @ApiPropertyOptional({ nullable: true }) severity: string | null;
  @ApiProperty({ type: [Number] }) articles: number[];
  @ApiProperty({ type: [String] }) quotes: string[];
  @ApiProperty() explanation: string;
}

export class VerificationDto {
  @ApiProperty({ enum: ['confirmed', 'unconfirmed'] }) status: 'confirmed' | 'unconfirmed';
  @ApiProperty({ enum: ['confirmed', 'refuted', 'uncertain'] }) basis: 'confirmed' | 'refuted' | 'uncertain';
  @ApiProperty() reason: string;
  @ApiPropertyOptional({ nullable: true }) quote: string | null;
}

export class ContractClauseResponseDto {
  @ApiProperty() id: string;
  @ApiProperty() clause_index: number;
  @ApiProperty() clause_label: string;
  @ApiPropertyOptional({ nullable: true }) clause_title: string | null;
  @ApiPropertyOptional({ nullable: true }) clause_type_guess: string | null;
  @ApiProperty() clause_text: string;
  @ApiPropertyOptional({ nullable: true }) assessment_status: ClauseAssessmentStatus | null;
  @ApiPropertyOptional({ nullable: true }) assessment_reasoning: string | null;
  @ApiPropertyOptional({ type: [MatchedArticleDto] }) matched_articles: MatchedArticle[] | null;
  @ApiPropertyOptional({ nullable: true }) assessment_confidence: number | null;
  @ApiPropertyOptional({ type: [RuleFindingDto], nullable: true }) rule_findings: RuleFindingDto[] | null;
  @ApiPropertyOptional({ type: VerificationDto, nullable: true, description: 'نتيجة المدقق المستقل؛ null = لم يُجرَ التحقق' }) verification: VerificationDto | null;
  @ApiPropertyOptional({ type: SuggestedRedraftDto, nullable: true }) suggested_redraft: SuggestedRedraftDto | null;
}
