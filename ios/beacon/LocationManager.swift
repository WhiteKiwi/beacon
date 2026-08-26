import Combine
import CoreLocation
import Foundation

struct LocationEntry: Codable, Identifiable {
    let id: UUID
    let timestamp: Date
    let latitude: Double
    let longitude: Double
    let success: Bool
}

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    static let shared = LocationManager()

    @Published var history: [LocationEntry] = []

    private let manager = CLLocationManager()
    private let historyKey = "locationHistory"
    private let maxHistory = 10
    private static let iso8601 = ISO8601DateFormatter()
    private var manualSendCompletion: ((String?) -> Void)?

    private override init() {
        super.init()
        manager.delegate = self
        loadHistory()
    }

    func start() {
        advanceAuthorizationAndMonitoring()
    }

    func resumeMonitoring() {
        guard manager.authorizationStatus == .authorizedAlways else { return }
        startSignificantLocationMonitoringIfAvailable()
    }

    func sendManually(completion: @escaping (String?) -> Void) {
        guard manualSendCompletion == nil else {
            completion("이미 현재 위치를 확인하고 있습니다.")
            return
        }

        manualSendCompletion = completion
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            manager.requestLocation()
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .denied, .restricted:
            finishManualSend(error: "위치 접근이 허용되지 않았습니다.\n설정에서 Beacon의 위치 권한을 허용해 주세요.")
        @unknown default:
            finishManualSend(error: "현재 위치 권한 상태를 확인할 수 없습니다.")
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        post(location: location) { [weak self] error in
            self?.appendHistory(location, success: error == nil)
            self?.finishManualSend(error: error)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        guard manualSendCompletion != nil else { return }
        finishManualSend(error: "현재 위치를 가져오지 못했습니다.\n잠시 후 다시 시도해 주세요.\n\(error.localizedDescription)")
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways:
            startSignificantLocationMonitoringIfAvailable()
            requestManualLocationIfNeeded()
        case .authorizedWhenInUse:
            requestManualLocationIfNeeded()
            manager.requestAlwaysAuthorization()
        case .denied, .restricted:
            finishManualSend(error: "위치 접근이 허용되지 않았습니다.\n설정에서 Beacon의 위치 권한을 허용해 주세요.")
        case .notDetermined:
            break
        @unknown default:
            finishManualSend(error: "현재 위치 권한 상태를 확인할 수 없습니다.")
        }
    }

    private func advanceAuthorizationAndMonitoring() {
        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse:
            manager.requestAlwaysAuthorization()
        case .authorizedAlways:
            startSignificantLocationMonitoringIfAvailable()
        case .denied, .restricted:
            break
        @unknown default:
            break
        }
    }

    private func startSignificantLocationMonitoringIfAvailable() {
        guard CLLocationManager.significantLocationChangeMonitoringAvailable() else { return }
        manager.startMonitoringSignificantLocationChanges()
    }

    private func requestManualLocationIfNeeded() {
        guard manualSendCompletion != nil else { return }
        manager.requestLocation()
    }

    private func finishManualSend(error: String?) {
        guard let completion = manualSendCompletion else { return }
        manualSendCompletion = nil
        DispatchQueue.main.async {
            completion(error)
        }
    }

    private func appendHistory(_ location: CLLocation, success: Bool) {
        let entry = LocationEntry(
            id: UUID(),
            timestamp: location.timestamp,
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude,
            success: success
        )
        DispatchQueue.main.async {
            let idx = self.history.firstIndex(where: { $0.timestamp < entry.timestamp }) ?? self.history.endIndex
            self.history.insert(entry, at: idx)
            if self.history.count > self.maxHistory {
                self.history.removeLast()
            }
            self.saveHistory()
        }
    }

    private func post(location: CLLocation, completion: @escaping (String?) -> Void) {
        let defaults = UserDefaults.standard
        guard
            let serverURL = defaults.string(forKey: "serverURL"),
            let url = URL(string: serverURL)
        else {
            completion("서버 URL이 설정되지 않았습니다.")
            return
        }

        let id = defaults.string(forKey: "deviceID") ?? ""
        let secret = CredentialsStore.apiSecret
        let body: [String: Any] = [
            "id": id,
            "latitude": location.coordinate.latitude,
            "longitude": location.coordinate.longitude,
            "timestamp": Self.iso8601.string(from: location.timestamp)
        ]

        guard let data = try? JSONSerialization.data(withJSONObject: body) else {
            completion("요청 직렬화에 실패했습니다.")
            return
        }

        var request = URLRequest(url: url, timeoutInterval: 5)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(secret)", forHTTPHeaderField: "Authorization")
        request.httpBody = data

        URLSession.shared.dataTask(with: request) { data, response, error in
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
