# Google Analytics setup

Beacon uses Google Analytics 4 through Firebase Analytics. The app links the
`FirebaseAnalyticsCore` Swift Package product so it does not collect IDFA.

## Firebase configuration

- Firebase project: `Beacon`
- Firebase project ID: `beacon-75169`
- iOS app nickname: `Beacon iOS`
- Bundle ID: `link.whitekiwi.beacon`
- Local config: `ios/beacon/GoogleService-Info.plist`
- Bitwarden backup: `Beacon — Google and Firebase Configuration`

`GoogleService-Info.plist` is intentionally gitignored and must be restored from
Bitwarden on a new checkout. The app still builds and runs without it, but
analytics is disabled until the file is included in the app bundle.

## Events

| Event | Parameters | Meaning |
| --- | --- | --- |
| `screen_view` | `screen_name`, `screen_class` | Setup, home, or settings was shown |
| `setup_completed` | None | Initial setup was completed |
| `manual_location_send` | `result` | A manual send succeeded or failed |

Coordinates, Device ID, server URL, and API Secret are never attached to
analytics events.

## Debug verification

Add `-FIRAnalyticsDebugEnabled` to the app scheme's launch arguments, run the
app, and inspect Analytics DebugView in the Firebase console. Remove the launch
argument after verification.

Before distributing the app, update the App Store Connect privacy disclosure
and the app privacy policy to reflect Firebase Analytics collection.
