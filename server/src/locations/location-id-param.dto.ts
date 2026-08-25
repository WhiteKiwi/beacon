import { Matches, MaxLength } from 'class-validator';
import { LOCATION_ID_MAX_LENGTH, LOCATION_ID_PATTERN } from './location.dto.js';

export class LocationIdParamDto {
  @MaxLength(LOCATION_ID_MAX_LENGTH, {
    message: 'id는 128자 이하여야 합니다.',
  })
  @Matches(LOCATION_ID_PATTERN, {
    message: 'id는 영문, 숫자, 하이픈, 밑줄만 사용할 수 있습니다.',
  })
  id!: string;
}
