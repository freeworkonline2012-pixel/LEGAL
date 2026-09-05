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
}
