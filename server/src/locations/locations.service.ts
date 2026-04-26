import { BadRequestException, Injectable, OnModuleInit } from '@nestjs/common';
import { mkdirSync, readdirSync, readFileSync, promises } from 'fs';
import { join } from 'path';
import { LocationDto, LOCATION_ID_PATTERN } from './location.dto.js';

const DATA_DIR = join(process.cwd(), '.data');
const MAX_ENTRIES = 50;

function assertSafeId(id: string): string {
  if (!LOCATION_ID_PATTERN.test(id)) {
    throw new BadRequestException(
      'id는 영문, 숫자, 하이픈, 밑줄만 사용할 수 있습니다.',
    );
  }
  return id;
}

@Injectable()
export class LocationsService implements OnModuleInit {
  private cache = new Map<string, LocationDto[]>();

  onModuleInit() {
    mkdirSync(DATA_DIR, { recursive: true });

    for (const file of readdirSync(DATA_DIR)) {
      if (!file.endsWith('.json')) continue;
      const id = file.slice(0, -5);
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
    const entries = this.cache.get(id) ?? [];
    const updated = [...entries, location].slice(-MAX_ENTRIES);

    this.cache.set(id, updated);
    void promises.writeFile(
      join(DATA_DIR, `${id}.json`),
      JSON.stringify(updated, null, 2),
    );
  }

  getLatest(id: string): LocationDto | undefined {
    return this.cache.get(assertSafeId(id))?.at(-1);
  }
}
