import SwiftUI

@main
struct BeaconApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let defaults = UserDefaults.standard
        let legacyBaseURL = "https://macmini.whitekiwi.link:10422"
        let currentBaseURL = "https://beacon.whitekiwi.link"
        if let serverURL = defaults.string(forKey: "serverURL"),
           serverURL.hasPrefix(legacyBaseURL) {
            defaults.set(
                currentBaseURL + String(serverURL.dropFirst(legacyBaseURL.count)),
                forKey: "serverURL"
            )
        }
        AppAnalytics.configure()
        if defaults.bool(forKey: "isActivated") {
            LocationManager.shared.resumeMonitoring()
        }
        return true
    }
}
