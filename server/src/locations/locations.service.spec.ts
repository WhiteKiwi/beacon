import {
  mkdtempSync,
  mkdirSync,
  readFileSync,
  readdirSync,
  rmSync,
  writeFileSync,
  promises,
} from 'fs';
import { tmpdir } from 'os';
import { join } from 'path';
import {
  BadRequestException,
  ServiceUnavailableException,
} from '@nestjs/common';
import { MAX_TRACKED_IDS, LocationsService } from './locations.service.js';

const loc = (n: number) => ({
  id: 'kiwi',
  latitude: n,
  longitude: n,
  timestamp: `2026-01-01T00:00:${String(n % 60).padStart(2, '0')}Z`,
});

describe('LocationsService durable files', () => {
  let folder: string;
  let service: LocationsService;
  const create = () => {
    const instance = new LocationsService();
    Reflect.set(instance, 'dataDir', folder);
    instance.onModuleInit();
    return instance;
  };
  beforeEach(() => {
    folder = mkdtempSync(join(tmpdir(), 'beacon-files-'));
    service = create();
  });
  afterEach(async () => {
    jest.restoreAllMocks();
    await service.onModuleDestroy();
    rmSync(folder, { recursive: true, force: true });
  });
  it('success survives a new service reading the same directory', async () => {
    await service.save(loc(1));
    expect(create().getLatest('kiwi')).toEqual(loc(1));
  });
  it('concurrent saves keep the final 50 entries in arrival order', async () => {
    await Promise.all(
      Array.from({ length: 60 }, (_, i) => service.save(loc(i))),
    );
    const saved = JSON.parse(
      readFileSync(join(folder, 'kiwi.json'), 'utf8'),
    ) as unknown[];
    expect(saved).toEqual(Array.from({ length: 50 }, (_, i) => loc(i + 10)));
    expect(create().getLatest('kiwi')).toEqual(loc(59));
    expect(readdirSync(folder)).toEqual(['kiwi.json']);
  });
  it('failed persistence is rejected without updating cache, then recovers', async () => {
    await service.save(loc(1));
    const rename = jest
      .spyOn(promises, 'rename')
      .mockRejectedValueOnce(new Error('disk failure'));
    await expect(service.save(loc(2))).rejects.toBeInstanceOf(
      ServiceUnavailableException,
    );
    expect(service.getLatest('kiwi')).toEqual(loc(1));
    expect(create().getLatest('kiwi')).toEqual(loc(1));
    rename.mockRestore();
    await service.save(loc(3));
    expect(create().getLatest('kiwi')).toEqual(loc(3));
  });
  it('shutdown drains accepted saves and rejects new requests', async () => {
    const accepted = service.save(loc(1));
    await service.onModuleDestroy();
    await accepted;
    expect(create().getLatest('kiwi')).toEqual(loc(1));
    expect(() => service.save(loc(2))).toThrow(ServiceUnavailableException);
  });
  it('simultaneous new IDs cannot exceed capacity', async () => {
    Reflect.set(
      service,
      'cache',
      new Map(
        Array.from({ length: MAX_TRACKED_IDS - 1 }, (_, i) => [
          `id-${i}`,
          [loc(1)],
        ]),
      ),
    );
    const results = await Promise.allSettled([
      service.save({ ...loc(1), id: 'last' }),
      service.save({ ...loc(1), id: 'overflow' }),
    ]);
    expect(results[0].status).toBe('fulfilled');
    expect(results[1].status).toBe('rejected');
    expect(service.getLatest('overflow')).toBeUndefined();
  });
  it('rejects unsafe IDs before scheduling writes', () => {
    expect(() => service.save({ ...loc(1), id: '../secret' })).toThrow(
      BadRequestException,
    );
    expect(() => service.save({ ...loc(1), id: 'a'.repeat(129) })).toThrow(
      BadRequestException,
    );
    expect(() => service.getLatest('../secret')).toThrow(BadRequestException);
  });
  it('loads existing JSON and ignores non-JSON lock files', () => {
    writeFileSync(join(folder, 'kiwi.json'), JSON.stringify([loc(1)]));
    writeFileSync(join(folder, '.writer.lock'), '');
    expect(create().getLatest('kiwi')).toEqual(loc(1));
  });
  it('failed rename leaves previous JSON intact and no temporary file', async () => {
    await service.save(loc(1));
    mkdirSync(join(folder, 'blocked.json'));
    await expect(
      service.save({ ...loc(2), id: 'blocked' }),
    ).rejects.toBeInstanceOf(ServiceUnavailableException);
    expect(create().getLatest('kiwi')).toEqual(loc(1));
    expect(readdirSync(folder).some((name) => name.endsWith('.tmp'))).toBe(
      false,
    );
  });
});
