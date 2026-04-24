import {
  Body,
  Controller,
  Get,
  NotFoundException,
  Param,
  Post,
  UseGuards,
} from '@nestjs/common';
import { AuthGuard } from '../auth.guard.js';
import { LocationDto } from './location.dto.js';
import { LocationsService } from './locations.service.js';

@Controller('locations')
@UseGuards(AuthGuard)
export class LocationsController {
  constructor(private readonly locations: LocationsService) {}

  @Post()
  save(@Body() dto: LocationDto): void {
    this.locations.save(dto);
  }

  @Get(':id/latest')
  getLatest(@Param('id') id: string): LocationDto {
    const location = this.locations.getLatest(id);
    if (!location) throw new NotFoundException();
    return location;
  }
}
