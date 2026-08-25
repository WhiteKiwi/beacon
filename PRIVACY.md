# Beacon Privacy Policy / 개인정보 처리방침

Effective date / 시행일: August 25, 2026

Beacon sends significant location changes from your iPhone to an HTTPS endpoint that you
configure. This policy explains what the app processes and the choices available to you.

Beacon은 사용자가 직접 설정한 HTTPS 엔드포인트로 iPhone의 중요한 위치 변경을 전송합니다.
이 문서는 앱이 처리하는 정보와 사용자가 선택할 수 있는 사항을 설명합니다.

## Data processed / 처리하는 정보

- **Precise location / 정확한 위치:** latitude, longitude, and timestamp are sent only after
  you grant iOS location permission. They are used to provide the app's core location-delivery
  feature.
- **Device label / 기기 식별 이름:** the Device ID that you enter is sent with location data so
  your server can distinguish devices. Beacon does not require an account, legal name, email
  address, or phone number.
- **Server configuration / 서버 설정:** the endpoint and Device ID are stored on your device.
  The API secret is stored in the iOS Keychain and is sent only to the configured endpoint as an
  authorization header.
- **On-device history / 기기 내 기록:** the ten most recent send attempts, including coordinates,
  timestamps, and success status, are stored locally on your device.

## Optional analytics / 선택적 분석

Firebase Analytics is disabled by default. If you explicitly enable anonymous usage analytics,
Google Firebase may process an app-instance identifier, approximate geography derived from IP,
device/OS information, app opens, screen views, and the success or failure of manual send actions.
Beacon does not send precise location, the API secret, server URL, or Device ID to Firebase. The
app does not include IDFA support, advertising, cross-app tracking, or data brokerage.

익명 사용 분석은 기본적으로 꺼져 있습니다. 사용자가 직접 허용한 경우에만 Firebase가 앱 인스턴스
식별자, IP 기반 대략적 지역, 기기/OS 정보, 앱 실행, 화면 조회, 수동 전송 성공 여부를 처리할 수
있습니다. 정확한 위치, API Secret, 서버 URL, Device ID는 Firebase 분석에 포함하지 않습니다.

## Storage and sharing / 보관 및 공유

Location data is delivered to the server selected by the user. Its retention and access controls
depend on that server's operator. The reference Beacon server keeps only a bounded recent history
per Device ID. Data is not sold. Optional analytics data is processed by Google according to the
Google Privacy Policy and Firebase terms.

위치 정보는 사용자가 선택한 서버로 전송되며 보관 기간과 접근 권한은 해당 서버 운영 정책을
따릅니다. Beacon 기준 서버는 Device ID별 최근 기록을 제한된 개수만 보관합니다. 정보를 판매하지
않으며, 선택적 분석 정보는 Google의 개인정보 처리방침과 Firebase 약관에 따라 처리됩니다.

## Your choices and deletion / 선택 및 삭제

- Revoke or change location access in **iOS Settings → Privacy & Security → Location Services**.
- Disable analytics at any time in Beacon settings. Disabling it resets the local Firebase
  analytics identifier and stops further analytics collection.
- Delete the app to remove its local settings and history. Keychain data may persist across an app
  reinstall according to iOS behavior.
- To request deletion of data held by the reference Beacon server, contact the address below and
  include only the Device ID concerned. Never send your API secret by email.

## Contact / 문의

For privacy questions or deletion requests: **jh145478@gmail.com**

Policy URL: <https://github.com/WhiteKiwi/beacon/blob/main/PRIVACY.md>
