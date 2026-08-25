# App Store submission metadata

This file is the non-secret source of truth for the first App Store submission. Review-only
credentials belong in Bitwarden and App Store Connect, never in this repository.

## Version 1.0

- **Name:** Beacon - 위치 공유
- **Subtitle:** 내 서버로 보내는 위치 비콘
- **Primary category:** Utilities
- **Release:** Automatically after approval
- **Privacy policy URL:** https://github.com/WhiteKiwi/beacon/blob/main/PRIVACY.md
- **Support URL:** https://github.com/WhiteKiwi/beacon/issues
- **Marketing URL:** https://github.com/WhiteKiwi/beacon
- **Copyright:** 2026 Jihoon Jang

### Description (Korean)

Beacon은 iPhone의 중요한 위치 변경을 감지해 사용자가 지정한 HTTPS 서버로 안전하게 전송하는
가벼운 위치 비콘입니다.

- iOS Significant Location Change 기반 저전력 백그라운드 전송
- 현재 위치 수동 전송
- 최근 10건의 전송 결과 확인
- 서버 URL, Device ID, API Secret 직접 설정
- API Secret은 iOS Keychain에 보관
- 익명 사용 분석은 기본적으로 꺼져 있으며 선택적으로 허용

Beacon은 위치 공유 플랫폼 계정 없이 사용자가 직접 운영하거나 신뢰하는 서버에 데이터를
전달합니다. 백그라운드 전송을 위해 위치 접근 권한 '항상 허용'이 필요합니다.

### Keywords

`위치,위치공유,비콘,GPS,백그라운드,서버,셀프호스팅,프라이버시,자동화`

## App Review access

The app has no user account. App Review receives a scoped Device ID and API secret stored in
Bitwarden. The dedicated endpoint validates the request and returns success without retaining the
reviewer's coordinates.

### Review notes

Beacon does not use an account login. The username and password fields contain the Device ID and
review-only API secret used during initial setup.

1. Enter the Server URL, Device ID, and API Secret supplied in App Review Information.
2. Tap Start.
3. Allow location while using the app, then select Always in iOS Settings if prompted.
4. Tap the paper-plane button. A successful send appears in the recent history.

The review endpoint validates requests but does not retain coordinates. Anonymous analytics is
off by default. Precise location is sent only after iOS permission is granted.

## App privacy answers

Conservative disclosures include optional analytics and third-party SDK behavior.

| Data type | Collected | Linked | Tracking | Purpose |
|---|---:|---:|---:|---|
| Precise Location | Yes | Yes | No | App Functionality |
| User ID (user-entered Device ID) | Yes | Yes | No | App Functionality |
| Coarse Location | Optional | No | No | Analytics |
| Device ID (Firebase app-instance identifier) | Optional | No | No | Analytics |
| Product Interaction | Optional | No | No | Analytics |
| Other Diagnostic Data (send outcome) | Optional | No | No | Analytics |

The app does not use advertising, IDFA, data brokerage, or cross-app tracking. Server URL, API
secret, Device ID, and precise coordinates are excluded from Firebase Analytics events.

## Screenshot set

- Locale: Korean
- Display: 6.5-inch iPhone, 1284 x 2778
- Upload: `fastlane/screenshots/ko-KR/01-setup.png`
- Do not upload local screenshots that contain failed requests, precise coordinates, credentials,
  permission dialogs, or simulator-only artifacts.

## Final checklist

- [ ] Clean CI run on the exact commit submitted
- [ ] TestFlight build reaches `VALID`
- [ ] Review-only endpoint returns HTTP 204 over valid TLS
- [ ] Review credentials are scoped and stored in Bitwarden
- [ ] Privacy policy is reachable without authentication
- [ ] App privacy answers match this document
- [ ] Age rating and primary category are complete
- [ ] Build, screenshot, review contact, and review notes are attached
- [x] `ITSAppUsesNonExemptEncryption` is `false` (standard Apple HTTPS only)
