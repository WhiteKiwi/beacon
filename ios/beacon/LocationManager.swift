import CoreLocation
import Foundation

class LocationManager: NSObject, CLLocationManagerDelegate {
    static let shared = LocationManager()

    private let manager = CLLocationManager()

    private override init() {
        super.init()
        manager.delegate = self
    }

    func start() {
        manager.requestAlwaysAuthorization()
        manager.startMonitoringSignificantLocationChanges()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        sendLocation(location)
    }

    private func sendLocation(_ location: CLLocation) {
        let defaults = UserDefaults.standard
        guard
            let serverURL = defaults.string(forKey: "serverURL"),
            let url = URL(string: serverURL)
        else { return }

        let id = defaults.string(forKey: "deviceID") ?? ""
        let body: [String: Any] = [
            "id": id,
            "latitude": location.coordinate.latitude,
            "longitude": location.coordinate.longitude,
            "timestamp": ISO8601DateFormatter().string(from: location.timestamp)
        ]

        guard let data = try? JSONSerialization.data(withJSONObject: body) else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = data

        URLSession.shared.dataTask(with: request).resume()
    }
}
