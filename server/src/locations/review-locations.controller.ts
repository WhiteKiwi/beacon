import { Body, Controller, HttpCode, Post, UseGuards } from '@nestjs/common';
import { ReviewAuthGuard } from '../review-auth.guard.js';
import { LocationDto } from './location.dto.js';

@Controller('api/review/locations')
@UseGuards(ReviewAuthGuard)
export class ReviewLocationsController {
  @Post()
  @HttpCode(204)
  receive(@Body() dto: LocationDto): void {
    // App Review requests are validated but intentionally not retained.
    void dto;
  }
}
