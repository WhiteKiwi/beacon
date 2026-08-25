import { Module } from '@nestjs/common';
import { LocationsController } from './locations.controller.js';
import { LocationsService } from './locations.service.js';
import { ReviewLocationsController } from './review-locations.controller.js';

@Module({
  controllers: [LocationsController, ReviewLocationsController],
  providers: [LocationsService],
})
export class LocationsModule {}
