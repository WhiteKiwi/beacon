# iOS 구현 결정 사항

## 위치 모니터링

- `startMonitoringSignificantLocationChanges()` 사용 (GPS 상시 사용 X)
- 셀 타워 기반 약 500m 이상 이동 시 트리거
- 배터리 소모가 낮고 앱 종료 상태에서도 OS가 재실행해서 콜백 호출
- 빠른 테스트가 필요하면 `startUpdatingLocation()`으로 임시 교체

## 백그라운드 재실행

- `AppDelegate.application(_:didFinishLaunchingWithOptions:)` 에서 항상 `LocationManager.shared.start()` 호출
- iOS가 위치 이벤트로 앱을 깨울 때도 `didFinishLaunching`이 실행되므로 별도 launch key 체크 불필요

## 온보딩 플로우

- `isActivated` (`UserDefaults`) 플래그로 설정 화면 ↔ 홈 화면 라우팅
- 세 필드(URL, ID, Secret) 모두 채워진 상태를 기준으로 라우팅하지 않음
  → `@AppStorage` 값이 즉시 저장되어 입력 중에 자동 전환되는 버그가 있었기 때문

## 이력 저장

- `UserDefaults`에 `[LocationEntry]` JSON으로 저장
- 앱의 `UserDefaults` 접근은 `PrivacyInfo.xcprivacy`에 승인 사유 `CA92.1`로 선언
- 최대 10건 유지 (초과 시 오래된 것 제거)
- 로드 시 `timestamp` 내림차순 정렬 (최신이 맨 위)
- `LocationEntry`에 `success: Bool` 포함
- 수동 전송은 성공/실패 여부를 응답 확인 후 이력에 기록 (실패도 포함)
- 자동 전송(significant change)은 HTTP 응답 대기 없이 `success: true`로 즉시 추가
  → 백그라운드 전송 결과를 UI에서 추적하는 것이 복잡하고 실패 시 재전송 정책도 없기 때문
- 홈 화면에서 성공/실패를 아이콘(✓ / ✕)과 색상으로 구분 표시

## 수동 전송 응답 처리

- completion 타입을 `Result<Void, String>` 대신 `String?`으로 정의
  → Swift에서 `String`은 `Error`를 준수하지 않음
- `nil` = 성공, 값 있음 = 에러 메시지
- 실패 응답은 JSON pretty print 후 alert으로 표시

## ATS (App Transport Security)

- `AppInfo.plist`에 `NSAllowsArbitraryLoads = YES` 설정
- 파일명을 `Info.plist`가 아닌 `AppInfo.plist`로 지정, 소스 그룹(`beacon/`) 바깥인 SRCROOT에 위치
  → `PBXFileSystemSynchronizedRootGroup` (Xcode 16)이 `Info.plist`를 리소스로 자동 포함해
     "Multiple commands produce Info.plist" 빌드 오류가 발생했기 때문

## 인증

- `Authorization: Bearer {apiSecret}` 헤더를 모든 전송 요청에 포함
- `apiSecret`은 `UserDefaults`에 저장, 설정 화면에서 `SecureField`로 입력
