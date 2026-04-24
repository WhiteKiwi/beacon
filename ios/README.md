# Beacon iOS

## 동작 방식

1. 앱 실행 → 서버 URL + Device ID 입력 → 저장 및 시작
2. iOS `startMonitoringSignificantLocationChanges()` 활성화
3. 위치가 크게 변경될 때마다 서버로 HTTP POST 전송
4. 앱이 백그라운드/종료 상태여도 동작 (iOS가 앱을 깨워서 전송)
5. 최근 전송 이력 10건을 앱 화면에서 확인 가능

## 요구사항

- iOS 14+
- 실기기 필요 (시뮬레이터는 significant location change 미지원)
- 위치 권한: **항상 허용** (백그라운드 전송을 위해 필요)

## 빌드 방법

1. `ios/beacon.xcodeproj` Xcode로 열기
2. Signing & Capabilities → Team을 본인 Apple ID로 설정
3. iPhone 연결 후 상단에서 기기 선택
4. `Cmd + R` 로 빌드 및 실행

## Significant Location Change

- 셀 타워 기반으로 약 500m 이상 이동 시 트리거
- 배터리 소모가 낮음 (GPS 상시 사용 없음)
- 앱이 종료된 상태에서도 iOS가 재실행하여 콜백 호출
