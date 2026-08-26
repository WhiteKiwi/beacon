# App Store submission metadata

This file is the non-secret source of truth for the first App Store submission. Review-only
credentials belong in Bitwarden and App Store Connect, never in this repository.

## Version 1.0

- **Name:** Beacon - 위치 공유
- **Subtitle:** 내 서버로 보내는 위치 비콘
- **Primary category:** Utilities
- **Release:** Automatically after approval
- **Privacy policy URL:** https://github.com/WhiteKiwi/beacon/blob/main/PRIVACY.md
- **Support URL:** https://github.com/WhiteKiwi/beacon/blob/main/SUPPORT.md
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
3. Allow location while using the app, then select Always when iOS presents the follow-up prompt.
4. Tap the paper-plane button. Beacon requests a fresh location and a successful send appears in
   the recent history.

The review endpoint validates requests but does not retain coordinates. Anonymous analytics is
off by default. Precise location is sent only after iOS permission is granted.

### New app review information

1. **Physical-device recording:** Attach a recording from an iPhone 17 Pro on iOS 26.6. The
   recording begins with launching Beacon and shows setup, both location permission prompts, a
   manual location send, the successful history entry, and the settings screen.
2. **Test devices:** iPhone 17 Pro (iOS 26.6), plus layout verification on iPhone 14 Plus and
   13-inch iPad simulators (iOS 26.5).
3. **Functions and audience:** Beacon is a utility for privacy-conscious individuals, developers,
   and home-automation users who want their own iPhone to send significant location changes to an
   HTTPS endpoint they control. It provides low-power background delivery, an explicit fresh-location
   send, and a local history of the ten most recent attempts. It solves the need to automate from
   location data without creating an account with a location-sharing platform.
4. **Access:** No account registration, login, subscription, purchase, sample file, user-generated
   content, or account deletion flow exists. Use the Server URL, Device ID, and review-only API
   secret supplied in App Review Information, follow the four setup steps above, and accept the iOS
   location prompts. The review endpoint validates the request without retaining coordinates.
5. **External services:** Apple Core Location provides the location and significant-change events;
   the user-configured HTTPS endpoint receives core location requests; Apple Keychain stores the API
   secret; and Firebase Analytics is an optional, default-off analytics service. GitHub hosts the
   public privacy and support documents. The app uses no authentication provider, payment processor,
   advertising network, AI service, or external content provider.
6. **Regions:** Features and content operate consistently in every region. There are no regional
   restrictions or differences.
7. **Regulated or protected material:** Beacon does not operate in a regulated industry and contains
   no protected third-party material, so no authorization documentation is applicable.

## App privacy answers

Conservative disclosures include optional analytics and third-party SDK behavior.

| Data type | Collected | Linked | Tracking | Purpose |
|---|---:|---:|---:|---|
| Precise Location | Yes | Yes | No | App Functionality |
| User ID (user-entered Device ID) | Yes | Yes | No | App Functionality |
| Coarse Location | Optional | No | No | Analytics |
| Device ID (Firebase app-instance identifier) | Optional | No | No | Analytics |
| Product Interaction | Optional | No | No | Analytics |

The app does not use advertising, IDFA, data brokerage, or cross-app tracking. Server URL, API
secret, Device ID, and precise coordinates are excluded from Firebase Analytics events.

## Screenshot set

- Locale: Korean
- Display: 6.5-inch iPhone, 1284 x 2778
- Upload: `fastlane/screenshots/ko-KR/01-setup.png`
- Do not upload local screenshots that contain failed requests, precise coordinates, credentials,
  permission dialogs, or simulator-only artifacts.

## Final checklist

- [x] Clean CI run on the exact commit submitted
- [x] TestFlight build reaches `VALID`
- [x] Review-only endpoint returns HTTP 204 over valid TLS
- [x] Review credentials are scoped and stored in Bitwarden
- [x] Privacy policy is reachable without authentication
- [x] Support page provides a public contact method without requiring a GitHub account
- [x] App privacy answers match this document
- [x] Age rating (4+) and primary category (Utilities) are complete
- [x] Build, iPhone and 13-inch iPad screenshots, review contact, and review notes are attached
- [x] Starting price is free in all storefronts
- [x] `ITSAppUsesNonExemptEncryption` is `false` (standard Apple HTTPS only)
- [x] EU DSA account status is non-trader; it can be overridden per app later
- [x] Korea compliance contact verification is complete; the BRN is stored only in Bitwarden
- [x] Version 1.0 (build 202608250838) received a Guideline 2.1 information request
- [x] Replacement build 202608261619 is processed and ready to submit
- [x] Support URL and the seven requested App Review Information answers are saved
- [x] Replacement build 202608261619 is selected for version 1.0
- [ ] Attach the physical-device screen recording and submit the review update
