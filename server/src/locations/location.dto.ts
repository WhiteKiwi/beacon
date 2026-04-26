import {
  IsISO8601,
  IsNumber,
  IsString,
  Matches,
  Max,
  MaxLength,
  Min,
} from 'class-validator';

export const LOCATION_ID_PATTERN = /^[A-Za-z0-9_-]+$/;
export const LOCATION_ID_MAX_LENGTH = 128;

export class LocationDto {
  @IsString()
  @MaxLength(LOCATION_ID_MAX_LENGTH, {
    message: 'id는 128자 이하여야 합니다.',
  })
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
