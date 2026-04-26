import {
  BadRequestException,
  Injectable,
  Logger,
  OnModuleInit,
} from '@nestjs/common';
import { mkdirSync, readdirSync, readFileSync, promises } from 'fs';
import { join } from 'path';
import {
  LocationDto,
  LOCATION_ID_MAX_LENGTH,
  LOCATION_ID_PATTERN,
} from './location.dto.js';

const DATA_DIR = join(process.cwd(), '.data');
const MAX_ENTRIES = 50;
export const MAX_TRACKED_IDS = 1000;

function assertSafeId(id: string): string {
  if (
    id.length === 0 ||
    id.length > LOCATION_ID_MAX_LENGTH ||
    !LOCATION_ID_PATTERN.test(id)
  ) {
    throw new BadRequestException(
      'id는 128자 이하의 영문, 숫자, 하이픈, 밑줄만 사용할 수 있습니다.',
    );
  }
  return id;
}

@Injectable()
export class LocationsService implements OnModuleInit {
  private readonly logger = new Logger(LocationsService.name);
  private cache = new Map<string, LocationDto[]>();

  onModuleInit() {
    mkdirSync(DATA_DIR, { recursive: true });

    for (const file of readdirSync(DATA_DIR)) {
      if (!file.endsWith('.json')) continue;
      const id = file.slice(0, -5);
      if (
        id.length === 0 ||
        id.length > LOCATION_ID_MAX_LENGTH ||
        !LOCATION_ID_PATTERN.test(id)
      ) {
        this.logger.warn(`skipping unsafe location file name: ${file}`);
        continue;
      }
      try {
        const raw = readFileSync(join(DATA_DIR, file), 'utf-8');
        this.cache.set(id, JSON.parse(raw) as LocationDto[]);
      } catch {
        // 파일이 손상된 경우 무시
      }
    }
  }

  save(location: LocationDto): void {
    const id = assertSafeId(location.id);
    const exists = this.cache.has(id);
    if (!exists && this.cache.size >= MAX_TRACKED_IDS) {
      throw new BadRequestException(
        `저장 가능한 id 수를 초과했습니다. 최대 ${MAX_TRACKED_IDS}개까지만 허용됩니다.`,
      );
    }
    const entries = this.cache.get(id) ?? [];
    const updated = [...entries, location].slice(-MAX_ENTRIES);

    this.cache.set(id, updated);
    void promises
      .writeFile(join(DATA_DIR, `${id}.json`), JSON.stringify(updated, null, 2))
      .catch((error: unknown) => {
        this.logger.error(
          `failed to persist locations for id=${id}`,
          error instanceof Error ? error.stack : undefined,
        );
      });
  }

  getLatest(id: string): LocationDto | undefined {
    return this.cache.get(assertSafeId(id))?.at(-1);
  }
}
