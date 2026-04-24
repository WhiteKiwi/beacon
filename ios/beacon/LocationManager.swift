import CoreLocation
import Foundation

struct LocationEntry: Codable, Identifiable {
    let id: UUID
    let timestamp: Date
    let latitude: Double
    let longitude: Double
}

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    static let shared = LocationManager()

    @Published var history: [LocationEntry] = []

    private let manager = CLLocationManager()
    private let historyKey = "locationHistory"
    private let maxHistory = 10

    private override init() {
        super.init()
        manager.delegate = self
        loadHistory()
    }

    func start() {
        manager.requestAlwaysAuthorization()
        manager.startMonitoringSignificantLocationChanges()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        appendHistory(location)
        sendLocation(location)
    }

    private func appendHistory(_ location: CLLocation) {
        let entry = LocationEntry(
            id: UUID(),
            timestamp: location.timestamp,
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude
        )
        DispatchQueue.main.async {
            self.history.insert(entry, at: 0)
            if self.history.count > self.maxHistory {
                self.history = Array(self.history.prefix(self.maxHistory))
            }
            self.saveHistory()
        }
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

    private func saveHistory() {
        guard let data = try? JSONEncoder().encode(history) else { return }
        UserDefaults.standard.set(data, forKey: historyKey)
    }

    private func loadHistory() {
        guard
            let data = UserDefaults.standard.data(forKey: historyKey),
            let saved = try? JSONDecoder().decode([LocationEntry].self, from: data)
        else { return }
        history = saved
    }
}
