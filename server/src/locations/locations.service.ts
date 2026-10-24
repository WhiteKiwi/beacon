import {
  BadRequestException,
  Injectable,
  Logger,
  OnModuleInit,
  OnModuleDestroy,
  ServiceUnavailableException,
} from '@nestjs/common';
import { mkdirSync, readdirSync, readFileSync, promises } from 'fs';
import { join } from 'path';
import { randomUUID } from 'crypto';
import {
  LocationDto,
  LOCATION_ID_MAX_LENGTH,
  LOCATION_ID_PATTERN,
} from './location.dto.js';

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
export class LocationsService implements OnModuleInit, OnModuleDestroy {
  private readonly logger = new Logger(LocationsService.name);
  private cache = new Map<string, LocationDto[]>();
  private readonly dataDir = join(process.cwd(), '.data');
  private pending: Promise<void> = Promise.resolve();
  private closing = false;

  onModuleInit() {
    mkdirSync(this.dataDir, { recursive: true });

    for (const file of readdirSync(this.dataDir)) {
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
        const raw = readFileSync(join(this.dataDir, file), 'utf-8');
        this.cache.set(id, JSON.parse(raw) as LocationDto[]);
      } catch {
        // 파일이 손상된 경우 무시
      }
    }
  }

  save(location: LocationDto): Promise<void> {
    const id = assertSafeId(location.id);
    if (this.closing) {
      throw new ServiceUnavailableException('서버가 종료 중입니다.');
    }
    // One queue also reserves new IDs atomically and recovers after a failed write.
    const saved = this.pending.then(async () => {
      if (!this.cache.has(id) && this.cache.size >= MAX_TRACKED_IDS) {
        throw new BadRequestException(
          `저장 가능한 id 수를 초과했습니다. 최대 ${MAX_TRACKED_IDS}개까지만 허용됩니다.`,
        );
      }
      const updated = [...(this.cache.get(id) ?? []), location].slice(
        -MAX_ENTRIES,
      );
      const temporary = join(this.dataDir, `.${randomUUID()}.tmp`);
      try {
        const file = await promises.open(temporary, 'wx', 0o640);
        try {
          await file.writeFile(JSON.stringify(updated, null, 2));
          await file.sync();
        } finally {
          await file.close();
        }
        await promises.rename(temporary, join(this.dataDir, `${id}.json`));
        const directory = await promises.open(this.dataDir, 'r');
        try {
          await directory.sync();
        } finally {
          await directory.close();
        }
        this.cache.set(id, updated);
      } catch {
        await promises.unlink(temporary).catch(() => undefined);
        this.logger.error('Location persistence failed');
        throw new ServiceUnavailableException('위치를 저장하지 못했습니다.');
      }
    });
    this.pending = saved.catch(() => undefined);
    return saved;
  }

  async onModuleDestroy(): Promise<void> {
    this.closing = true;
    await this.pending;
  }

  getLatest(id: string): LocationDto | undefined {
    return this.cache.get(assertSafeId(id))?.at(-1);
  }
}
