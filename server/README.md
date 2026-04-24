# Beacon Server

iOS 앱으로부터 위치 데이터를 수신하고 조회하는 NestJS 서버.

## API

### 위치 수신

```
POST /locations
Content-Type: application/json
```

**Request Body**

| 필드 | 타입 | 필수 | 설명 |
|---|---|---|---|
| `id` | `string` | ✓ | 디바이스 또는 사용자 식별자 |
| `latitude` | `number` | ✓ | 위도 (-90 ~ 90) |
| `longitude` | `number` | ✓ | 경도 (-180 ~ 180) |
| `timestamp` | `string` | ✓ | ISO 8601 형식 (`2026-04-24T10:00:00Z`) |

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
GET /locations/:id/latest
```

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
