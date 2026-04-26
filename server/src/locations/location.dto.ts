import { IsISO8601, IsNumber, IsString, Matches, Max, Min } from 'class-validator';

export const LOCATION_ID_PATTERN = /^[A-Za-z0-9_-]+$/;

export class LocationDto {
  @IsString()
  @Matches(LOCATION_ID_PATTERN, {
    message: 'id는 영문, 숫자, 하이픈, 밑줄만 사용할 수 있습니다.',
  })
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
