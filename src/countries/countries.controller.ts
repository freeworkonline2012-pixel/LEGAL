import { Controller, Get } from '@nestjs/common';
import { ApiOkResponse, ApiTags } from '@nestjs/swagger';
import { CountryListResponseDto } from './dto/country-response.dto';
import { CountriesService } from './countries.service';

/** قراءة عامة، بلا مصادقة — نفس نمط laws وguidance (تصفح عام للمحتوى القانونى). */
@ApiTags('countries')
@Controller('countries')
export class CountriesController {
  constructor(private readonly countriesService: CountriesService) {}

  @Get()
  @ApiOkResponse({
    description: 'قائمة الدول المستهدفة مع عدد القوانين الفعلى لكل دولة',
    type: CountryListResponseDto,
  })
  list(): Promise<CountryListResponseDto> {
    return this.countriesService.list();
  }
}
