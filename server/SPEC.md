# Beacon Server

iOS 앱으로부터 위치 데이터를 수신하고 조회하는 NestJS 서버.

## API

모든 API 요청은 다음 인증 헤더가 필요합니다.

```
Authorization: Bearer <token>
```

### 위치 수신

```
POST /api/locations
Content-Type: application/json
```

**Request Body**

| 필드 | 타입 | 필수 | 설명 |
|---|---|---|---|
| `id` | `string` | ✓ | 디바이스 또는 사용자 식별자. 영문, 숫자, 하이픈(`-`), 밑줄(`_`)만 허용 |
| `latitude` | `number` | ✓ | 위도 (-90 ~ 90) |
| `longitude` | `number` | ✓ | 경도 (-180 ~ 180) |
| `timestamp` | `string` | ✓ | ISO 8601 형식 (`2026-04-24T10:00:00Z`) |

`id`가 허용 규칙을 벗어나면 `400 Bad Request`를 반환한다.

**Example**

```json
{
  "id": "kiwi",
  "latitude": 37.566535,
  "longitude": 126.977969,
  "timestamp": "2026-04-24T10:00:00Z"
}
```

**Response**

```
201 Created
```

---

### 특정 ID의 최신 위치 조회

```
GET /api/locations/:id/latest
```

`id`가 허용 규칙을 벗어나면 `400 Bad Request`를 반환한다.

**Response**

```json
{
  "id": "kiwi",
  "latitude": 37.566535,
  "longitude": 126.977969,
  "timestamp": "2026-04-24T10:00:00Z"
}
```

## 실행

```bash
pnpm start:dev
```
