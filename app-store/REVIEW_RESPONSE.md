# App Review follow-up

Prepared for App Store Connect submission `81d08167-3c4d-4601-bfd6-ab92d6b020e7` and the
Guideline 2.1 information request. Do not add the review-only API secret to this file. It remains in
the App Store Connect password field and Bitwarden.

## Submission state

- App: Beacon - 위치 공유
- Version: 1.0
- Previous build: 202608250838
- Replacement build: 202608261619
- Replacement build status: Processed, selected, and saved for version 1.0
- App Review Information: support URL and all seven requested answers saved
- Remaining artifact: physical-device screen recording from iPhone 17 Pro on iOS 26.6

## App Review Information notes

Paste the following into the Notes field for the replacement submission:

```text
Beacon does not use an account login. The username and password fields contain the Device ID and review-only API secret used during initial setup.

Server URL: https://macmini.whitekiwi.link:10422/api/review/locations
Device ID: app-review

SETUP AND ACCESS
1. Enter the Server URL, Device ID, and API Secret supplied in App Review Information.
2. Tap Start.
3. Allow location while using the app, then select Always when iOS presents the follow-up prompt.
4. Tap the paper-plane button. Beacon requests a fresh location and a successful send appears in recent history.

The review endpoint validates requests but does not retain coordinates. Anonymous analytics is off by default. Precise location is sent only after iOS permission is granted.

1. PHYSICAL-DEVICE RECORDING
A recording from an iPhone 17 Pro on iOS 26.6 is attached to the Resolution Center reply. It begins with launching Beacon and shows initial setup, both location permission prompts, a manual location send, the successful history entry, and the settings screen.

2. TEST DEVICES
- iPhone 17 Pro, iOS 26.6 (physical device, complete functional flow)
- iPhone 14 Plus, iOS 26.5 simulator (layout verification)
- 13-inch iPad, iOS 26.5 simulator (layout verification)

3. FUNCTIONS, AUDIENCE, AND VALUE
Beacon is a utility for privacy-conscious individuals, developers, and home-automation users who want their own iPhone to send significant location changes to an HTTPS endpoint they control. It provides low-power background delivery, an explicit fresh-location send, and a local history of the ten most recent attempts. It enables location-based automation without requiring an account with a location-sharing platform.

4. ACCESS REQUIREMENTS
There is no account registration, login, subscription, purchase, sample file, user-generated content, or account deletion flow. Use the review configuration above and accept the iOS location prompts. The review endpoint does not retain the reviewer's coordinates.

5. EXTERNAL SERVICES
- Apple Core Location: location and significant-change events
- User-configured HTTPS endpoint: receives the app's core location requests
- Apple Keychain: stores the API secret on device
- Firebase Analytics: optional analytics, disabled by default
- GitHub: hosts the public privacy policy and support page

Beacon uses no authentication provider, payment processor, advertising network, AI service, or external content provider.

6. REGIONAL DIFFERENCES
Features and content operate consistently in every region. There are no regional restrictions or differences.

7. REGULATED INDUSTRY OR PROTECTED MATERIAL
Beacon does not operate in a regulated industry and contains no protected third-party material. No authorization documentation is applicable.
```

## Resolution Center reply

Attach the physical-device recording, then send this reply:

```text
Hello App Review,

Thank you for the request. We have updated the App Review Information Notes with all requested details and attached a screen recording captured on an iPhone 17 Pro running iOS 26.6. The recording begins with launching the app and demonstrates setup, the location permission prompts, a fresh manual location send, the successful local history entry, and settings.

Tested devices:
- iPhone 17 Pro, iOS 26.6 (physical device)
- iPhone 14 Plus, iOS 26.5 simulator (layout verification)
- 13-inch iPad, iOS 26.5 simulator (layout verification)

Beacon is a self-hosted location automation utility for individuals, developers, and home-automation users. It sends significant location changes to an HTTPS endpoint selected by the user and provides manual fresh-location delivery and a local send history. It has no account, payment, subscription, user-generated content, or regulated-industry functionality.

Setup instructions, review configuration, external-service details, regional availability, and the protected-material confirmation are included in the Notes field. The replacement build is 202608261619.

Best regards,
Jihoon Jang
```

## Recording shot list

Record in portrait on the physical iPhone with the replacement TestFlight build. Keep the status bar
visible and do not edit or speed up the video.

1. Begin on the iPhone Home Screen and launch Beacon.
2. Show the initial setup screen and its privacy explanation.
3. Enter the review Server URL and Device ID; enter the secret into the obscured SecureField.
4. Leave anonymous analytics disabled and tap Start.
5. Show the When In Use location prompt and allow it.
6. Show the Always location prompt and allow it. If iOS defers this prompt, open Settings and select
   Always while continuing the same recording.
7. Return to Beacon and tap the paper-plane button.
8. Wait until a successful entry appears in recent history.
9. Open Settings and briefly show the server configuration and analytics toggle. Do not reveal the
   API secret.
10. End the recording. Target duration: 60–90 seconds.

Before attaching, verify that the recording contains no notification previews, precise coordinates
outside Beacon's intended history screen, or visible credentials.
