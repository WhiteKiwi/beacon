import FirebaseAnalytics
import FirebaseCore
import Foundation
import os

enum AppAnalytics {
    private static let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "link.whitekiwi.beacon",
        category: "Analytics"
    )

    private(set) static var isConfigured = false

    static func configure() {
        guard !isConfigured else { return }

        guard
            let path = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist"),
            let options = FirebaseOptions(contentsOfFile: path)
        else {
            logger.notice("GoogleService-Info.plist not found; analytics is disabled")
            return
        }

        FirebaseApp.configure(options: options)
        isConfigured = true
        Analytics.setAnalyticsCollectionEnabled(
            UserDefaults.standard.bool(forKey: "analyticsEnabled")
        )
    }

    static func setCollectionEnabled(_ enabled: Bool) {
        guard isConfigured else { return }
        Analytics.setAnalyticsCollectionEnabled(enabled)
        if !enabled {
            Analytics.resetAnalyticsData()
        }
    }

    static func screen(_ name: String) {
        log(
            AnalyticsEventScreenView,
            parameters: [
                AnalyticsParameterScreenName: name,
                AnalyticsParameterScreenClass: name,
            ]
        )
    }

    static func log(_ name: String, parameters: [String: Any]? = nil) {
        guard
            isConfigured,
            UserDefaults.standard.bool(forKey: "analyticsEnabled")
        else { return }
        Analytics.logEvent(name, parameters: parameters)
    }
}
