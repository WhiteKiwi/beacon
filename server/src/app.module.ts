import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { LocationsModule } from './locations/locations.module.js';

@Module({
  imports: [ConfigModule.forRoot({ isGlobal: true }), LocationsModule],
})
export class AppModule {}
