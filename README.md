# Beacon

iOS 앱에서 위치 변화를 감지하여 지정한 서버로 실시간 전송하는 도구.

## 구성

- [`ios/`](./ios/SPEC.md) — iOS 앱
- [`server/`](./server/SPEC.md) — NestJS 서버 (수신 엔드포인트)

## 인증

모든 서버 엔드포인트는 `Authorization` 헤더에 Bearer 토큰이 필요합니다.

```
Authorization: Bearer {API_SECRET}
```

## API 스펙

### 위치 전송

```
POST {서버 URL}
Content-Type: application/json
```

```json
{
  "id": "device-identifier",
  "latitude": 37.123456,
  "longitude": 127.123456,
  "timestamp": "2026-04-24T10:00:00Z"
}
```
