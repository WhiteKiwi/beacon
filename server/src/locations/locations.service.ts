import { Injectable, OnModuleInit } from '@nestjs/common';
import {
  existsSync,
  mkdirSync,
  readdirSync,
  readFileSync,
  writeFileSync,
} from 'fs';
import { join } from 'path';
import { LocationDto } from './location.dto.js';

const DATA_DIR = join(process.cwd(), '.data');
const MAX_ENTRIES = 50;

@Injectable()
export class LocationsService implements OnModuleInit {
  private cache = new Map<string, LocationDto[]>();

  onModuleInit() {
    if (!existsSync(DATA_DIR)) return;

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
    this.persist(id, updated);
  }

  getLatest(id: string): LocationDto | undefined {
    const entries = this.cache.get(id);
    return entries?.at(-1);
  }

  private persist(id: string, entries: LocationDto[]): void {
    if (!existsSync(DATA_DIR)) mkdirSync(DATA_DIR, { recursive: true });
    writeFileSync(join(DATA_DIR, `${id}.json`), JSON.stringify(entries, null, 2));
  }
}
