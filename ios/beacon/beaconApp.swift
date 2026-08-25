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
        AppAnalytics.configure()
        if UserDefaults.standard.bool(forKey: "isActivated") {
            LocationManager.shared.resumeMonitoring()
        }
        return true
    }
}
