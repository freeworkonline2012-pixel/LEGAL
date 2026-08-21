import {
  Body,
  Controller,
  Get,
  Param,
  ParseUUIDPipe,
  Patch,
  Query,
  Req,
  UnauthorizedException,
  UseGuards,
} from '@nestjs/common';
import { ApiBearerAuth, ApiOkResponse, ApiTags } from '@nestjs/swagger';
import { Roles } from '../common/decorators/roles.decorator';
import { JwtAuthGuard } from '../common/guards/jwt-auth.guard';
import { RolesGuard } from '../common/guards/roles.guard';
import type { RequestWithUser } from '../common/interfaces/request-with-user.interface';
import { ReviewListResponseDto, ReviewResponseDto } from './dto/review-response.dto';
import { UpdateReviewDto } from './dto/update-review.dto';
import { ReviewsService } from './reviews.service';

@ApiTags('reviews')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard, RolesGuard)
@Controller('reviews')
export class ReviewsController {
  constructor(private readonly reviewsService: ReviewsService) {}

  @Get()
  @Roles('lawyer', 'admin')
  @ApiOkResponse({
    description: 'طابور المراجعة البشرية (lawyer/admin)',
    type: ReviewListResponseDto,
  })
  list(
    @Query('status') status?: string,
    @Query('limit') limit = 20,
    @Query('offset') offset = 0,
  ): Promise<ReviewListResponseDto> {
    const parsedLimit = Math.min(Math.max(Number(limit) || 20, 1), 100);
    const parsedOffset = Math.max(Number(offset) || 0, 0);
    return this.reviewsService.list(status, {
      limit: parsedLimit,
      offset: parsedOffset,
    });
  }

  @Patch(':id')
  @Roles('lawyer', 'admin')
  @ApiOkResponse({
    description: 'حسم مراجعة (lawyer/admin)',
    type: ReviewResponseDto,
  })
  update(
    @Param('id', new ParseUUIDPipe()) id: string,
    @Body() dto: UpdateReviewDto,
    @Req() request: RequestWithUser,
  ): Promise<ReviewResponseDto> {
    const user = request.user;
    if (!user) {
      throw new UnauthorizedException('update requires authenticated user');
    }
    return this.reviewsService.update(id, user.userId, dto);
  }
}
