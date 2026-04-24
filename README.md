# Beacon

iOS 앱에서 위치 변화를 감지하여 지정한 서버로 실시간 전송하는 도구.

## 구성

- [`ios/`](./ios/) — iOS 앱
- `server/` — NestJS 서버 (수신 엔드포인트)

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
