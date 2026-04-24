import { INestApplication } from '@nestjs/common';
import { Test } from '@nestjs/testing';
import request from 'supertest';
import { App } from 'supertest/types';
import { AppModule } from '../src/app.module.js';
import { LocationsService } from '../src/locations/locations.service.js';
import { validationPipe } from '../src/validation.pipe.js';

const SECRET = 'test-secret';
const AUTH = `Bearer ${SECRET}`;

const loc = {
  id: 'kiwi',
  latitude: 37.566535,
  longitude: 126.977969,
  timestamp: '2026-04-24T10:00:00Z',
};

const mockLocationsService = {
  save: jest.fn(),
  getLatest: jest.fn(),
  onModuleInit: jest.fn(),
};

describe('Locations (e2e)', () => {
  let app: INestApplication<App>;

  beforeAll(async () => {
    process.env['API_SECRET'] = SECRET;

    const moduleFixture = await Test.createTestingModule({
      imports: [AppModule],
    })
      .overrideProvider(LocationsService)
      .useValue(mockLocationsService)
      .compile();

    app = moduleFixture.createNestApplication();
    app.useGlobalPipes(validationPipe);
    await app.init();
  });

  beforeEach(() => jest.clearAllMocks());

  afterAll(async () => {
    await app.close();
    delete process.env['API_SECRET'];
  });

  describe('POST /locations', () => {
    it('유효한 토큰 → 201', () => {
      return request(app.getHttpServer())
        .post('/locations')
        .set('Authorization', AUTH)
        .send(loc)
        .expect(201);
    });

    it('토큰 없음 → 404', () => {
      return request(app.getHttpServer())
        .post('/locations')
        .send(loc)
        .expect(404);
    });

    it('잘못된 토큰 → 404', () => {
      return request(app.getHttpServer())
        .post('/locations')
        .set('Authorization', 'Bearer wrong')
        .send(loc)
        .expect(404);
    });

    it('latitude 범위 초과 → 400', () => {
      return request(app.getHttpServer())
        .post('/locations')
        .set('Authorization', AUTH)
        .send({ ...loc, latitude: 91 })
        .expect(400);
    });

    it('longitude 범위 초과 → 400', () => {
      return request(app.getHttpServer())
        .post('/locations')
        .set('Authorization', AUTH)
        .send({ ...loc, longitude: 181 })
        .expect(400);
    });

    it('timestamp ISO 형식 아님 → 400', () => {
      return request(app.getHttpServer())
        .post('/locations')
        .set('Authorization', AUTH)
        .send({ ...loc, timestamp: 'not-a-date' })
        .expect(400);
    });
  });

  describe('GET /locations/:id/latest', () => {
    it('데이터 있음 → 200 + location', () => {
      mockLocationsService.getLatest.mockReturnValue(loc);

      return request(app.getHttpServer())
        .get('/locations/kiwi/latest')
        .set('Authorization', AUTH)
        .expect(200)
        .expect(loc);
    });

    it('데이터 없음 → 404', () => {
      mockLocationsService.getLatest.mockReturnValue(undefined);

      return request(app.getHttpServer())
        .get('/locations/kiwi/latest')
        .set('Authorization', AUTH)
        .expect(404);
    });

    it('토큰 없음 → 404', () => {
      return request(app.getHttpServer())
        .get('/locations/kiwi/latest')
        .expect(404);
    });
  });
});
