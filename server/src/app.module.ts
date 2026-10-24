import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { LocationsModule } from './locations/locations.module.js';
import { HealthController } from './health.controller.js';

@Module({
  controllers: [HealthController],
  imports: [ConfigModule.forRoot({ isGlobal: true }), LocationsModule],
})
export class AppModule {}
