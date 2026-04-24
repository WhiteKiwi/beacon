import * as fs from 'fs';
import { LocationsService } from './locations.service.js';

jest.mock('fs', () => ({
  mkdirSync: jest.fn(),
  readdirSync: jest.fn().mockReturnValue([]),
  readFileSync: jest.fn(),
  promises: {
    writeFile: jest.fn().mockResolvedValue(undefined),
  },
}));

const loc = (n: number) => ({
  id: 'kiwi',
  latitude: n,
  longitude: n,
  timestamp: `2026-01-${String(n).padStart(2, '0')}T00:00:00Z`,
});

describe('LocationsService', () => {
  let service: LocationsService;

  beforeEach(() => {
    jest.clearAllMocks();
    (fs.readdirSync as jest.Mock).mockReturnValue([]);
    service = new LocationsService();
    service.onModuleInit();
  });

  describe('onModuleInit', () => {
    it('.data 디렉토리 생성', () => {
      expect(fs.mkdirSync as jest.Mock).toHaveBeenCalledWith(
        expect.stringContaining('.data'),
        { recursive: true },
      );
    });

    it('파일 없으면 캐시 비어있음', () => {
      expect(service.getLatest('kiwi')).toBeUndefined();
    });

    it('파일 있으면 캐시에 로드', () => {
      const entries = [loc(1)];
      (fs.readdirSync as jest.Mock).mockReturnValue(['kiwi.json']);
      (fs.readFileSync as jest.Mock).mockReturnValue(JSON.stringify(entries));

      service = new LocationsService();
      service.onModuleInit();

      expect(service.getLatest('kiwi')).toEqual(loc(1));
    });

    it('파일 손상 시 무시', () => {
      (fs.readdirSync as jest.Mock).mockReturnValue(['kiwi.json']);
      (fs.readFileSync as jest.Mock).mockReturnValue('invalid json');

      service = new LocationsService();
      expect(() => service.onModuleInit()).not.toThrow();
      expect(service.getLatest('kiwi')).toBeUndefined();
    });
  });

  describe('save', () => {
    it('저장 후 getLatest로 조회됨', () => {
      service.save(loc(1));
      expect(service.getLatest('kiwi')).toEqual(loc(1));
    });

    it('여러 건 저장 시 최신 항목 반환', () => {
      service.save(loc(1));
      service.save(loc(2));
      expect(service.getLatest('kiwi')).toEqual(loc(2));
    });

    it('50건 초과 시 오래된 것부터 제거', () => {
      for (let i = 1; i <= 51; i++) service.save(loc(i));
      expect(fs.promises.writeFile as jest.Mock).toHaveBeenLastCalledWith(
        expect.stringContaining('kiwi.json'),
        expect.stringContaining('"latitude": 51'),
      );
      expect(fs.promises.writeFile as jest.Mock).toHaveBeenLastCalledWith(
        expect.stringContaining('kiwi.json'),
        expect.not.stringContaining('"latitude": 1,'),
      );
    });

    it('파일에 비동기 persist 호출', () => {
      service.save(loc(1));
      expect(fs.promises.writeFile as jest.Mock).toHaveBeenCalledWith(
        expect.stringContaining('kiwi.json'),
        expect.any(String),
      );
    });
  });

  describe('getLatest', () => {
    it('없는 id → undefined', () => {
      expect(service.getLatest('unknown')).toBeUndefined();
    });
  });
});
