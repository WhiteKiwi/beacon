# Beacon

iOS 앱에서 위치 변화를 감지하여 지정한 서버로 실시간 전송하는 도구.

## 개요

앱 실행 후 서버 URL과 ID를 입력하면, iOS의 significant location change monitoring을 통해 위치가 크게 변할 때마다 해당 서버로 위치 데이터를 HTTP POST로 전송한다.

## 동작 방식

1. 앱 실행 → 서버 URL + ID 입력 → 저장
2. iOS `startMonitoringSignificantLocationChanges()` 활성화
3. 위치가 크게 변경될 때마다 서버로 위치 전송
4. 앱이 백그라운드/종료 상태여도 동작 (iOS가 앱을 깨워서 전송)

### 전송 데이터

```json
{
  "id": "user-identifier",
  "latitude": 37.123456,
  "longitude": 127.123456,
  "timestamp": "2026-04-24T10:00:00Z"
}
```

### 서버 엔드포인트

```
POST {저장된 서버 URL}
Content-Type: application/json
```

## 설정

앱 첫 화면에서 URL과 ID 입력 후 저장하면 `UserDefaults`에 유지된다.

## 요구사항

- iOS 14+
- 위치 권한: `Always` (백그라운드 전송을 위해 필요)
- `NSLocationAlwaysAndWhenInUseUsageDescription` — Info.plist에 설정 필요

## Significant Location Change란?

- 셀 타워 기반으로 약 500m 이상 이동 시 트리거
- 배터리 소모가 낮음 (GPS 상시 사용 없음)
- 앱이 종료된 상태에서도 iOS가 재실행하여 콜백 호출
