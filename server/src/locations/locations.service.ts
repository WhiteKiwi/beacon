import { Injectable, OnModuleInit } from '@nestjs/common';
import { mkdirSync, readdirSync, readFileSync, promises } from 'fs';
import { join } from 'path';
import { LocationDto } from './location.dto.js';

const DATA_DIR = join(process.cwd(), '.data');
const MAX_ENTRIES = 50;

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
    const { id } = location;
    const entries = this.cache.get(id) ?? [];
    const updated = [...entries, location].slice(-MAX_ENTRIES);

    this.cache.set(id, updated);
    void promises.writeFile(
      join(DATA_DIR, `${id}.json`),
      JSON.stringify(updated, null, 2),
    );
  }

  getLatest(id: string): LocationDto | undefined {
    return this.cache.get(id)?.at(-1);
  }
}
