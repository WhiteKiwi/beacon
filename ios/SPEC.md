# Beacon iOS

## 화면 구성

- **최초 실행** — 서버 URL, Device ID, API Secret 입력 후 시작
- **홈 화면** — 최근 전송 이력 10건 표시, 수동 전송 버튼 (좌상단 ✈️)
- **설정** — 홈 우상단 톱니바퀴 아이콘으로 진입, URL/ID/Secret 수정 가능

## 동작 방식

1. 최초 실행 → 설정 화면에서 서버 URL + Device ID + API Secret 입력 → 시작하기
2. 이후 실행 → 홈 화면 바로 표시, 위치 모니터링 자동 재개
3. iOS `startMonitoringSignificantLocationChanges()` 활성화
4. 위치가 크게 변경될 때마다 서버로 HTTP POST 전송
5. 앱이 백그라운드/종료 상태여도 동작 (iOS가 앱을 깨워서 전송)
6. 최근 전송 이력 10건을 홈 화면에서 확인 가능
7. 홈 좌상단 버튼으로 수동 전송 가능 — 성공 시 이력 업데이트, 실패 시 응답 팝업 표시

## 요구사항

- iOS 17+
- 실기기 필요 (시뮬레이터는 significant location change 미지원)
- 위치 권한: **항상 허용** (백그라운드 전송을 위해 필요)

## 설정 항목

| 항목 | 설명 |
|------|------|
| Server URL | 위치를 전송할 서버 엔드포인트 |
| Device ID | 기기 식별자 (전송 바디의 `id` 필드) |
| API Secret | Bearer 토큰 (`Authorization: Bearer {값}`) |

## 빌드 방법

1. `ios/beacon.xcodeproj` Xcode로 열기
2. Signing & Capabilities → Team을 본인 Apple ID로 설정
3. iPhone 연결 후 상단에서 기기 선택
4. `Cmd + R` 로 빌드 및 실행

## Significant Location Change

- 셀 타워 기반으로 약 500m 이상 이동 시 트리거
- 배터리 소모가 낮음 (GPS 상시 사용 없음)
- 앱이 종료된 상태에서도 iOS가 재실행하여 콜백 호출
