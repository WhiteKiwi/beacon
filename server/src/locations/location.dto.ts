import { IsISO8601, IsNumber, IsString, Max, Min } from 'class-validator';

export class LocationDto {
  @IsString()
  id!: string;

  @IsNumber()
  @Min(-90)
  @Max(90)
  latitude!: number;

  @IsNumber()
  @Min(-180)
  @Max(180)
  longitude!: number;

  @IsISO8601()
  timestamp!: string;
}
