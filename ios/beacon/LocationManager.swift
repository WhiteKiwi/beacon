import Combine
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

    // completion: nil = 성공, String = 에러 메시지
    func sendManually(completion: @escaping (String?) -> Void) {
        guard let location = manager.location else {
            completion("현재 위치를 가져올 수 없습니다.\n위치 권한을 확인해주세요.")
            return
        }
        post(location: location) { [weak self] error in
            if error == nil {
                self?.appendHistory(location)
            }
            completion(error)
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        appendHistory(location)
        post(location: location, completion: nil)
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

    private func post(location: CLLocation, completion: ((String?) -> Void)?) {
        let defaults = UserDefaults.standard
        guard
            let serverURL = defaults.string(forKey: "serverURL"),
            let url = URL(string: serverURL)
        else {
            completion?("서버 URL이 설정되지 않았습니다.")
            return
        }

        let id = defaults.string(forKey: "deviceID") ?? ""
        let secret = defaults.string(forKey: "apiSecret") ?? ""
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
        request.setValue("Bearer \(secret)", forHTTPHeaderField: "Authorization")
        request.httpBody = data

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let completion else { return }

            if let error = error {
                DispatchQueue.main.async { completion(error.localizedDescription) }
                return
            }

            let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
            if (200..<300).contains(statusCode) {
                DispatchQueue.main.async { completion(nil) }
            } else {
                let pretty = data.flatMap { Self.prettyJSON($0) } ?? "응답 없음"
                DispatchQueue.main.async { completion("[\(statusCode)]\n\(pretty)") }
            }
        }.resume()
    }

    private static func prettyJSON(_ data: Data) -> String? {
        guard
            let obj = try? JSONSerialization.jsonObject(with: data),
            let pretty = try? JSONSerialization.data(withJSONObject: obj, options: .prettyPrinted)
        else {
            return String(data: data, encoding: .utf8)
        }
        return String(data: pretty, encoding: .utf8)
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
        history = saved.sorted { $0.timestamp > $1.timestamp }
    }
}
