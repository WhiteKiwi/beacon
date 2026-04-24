import SwiftUI

struct ContentView: View {
    @AppStorage("serverURL") private var serverURL = ""
    @AppStorage("deviceID") private var deviceID = ""
    @AppStorage("apiSecret") private var apiSecret = ""
    @State private var isMonitoring = false
    @ObservedObject private var locationManager = LocationManager.shared

    private let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "MM/dd HH:mm:ss"
        return f
    }()

    var body: some View {
        NavigationStack {
            Form {
                Section("서버 설정") {
                    TextField("Server URL", text: $serverURL)
                        .keyboardType(.URL)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                    TextField("Device ID", text: $deviceID)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                    SecureField("API Secret", text: $apiSecret)
                }

                Section {
                    Button(isMonitoring ? "모니터링 중..." : "저장 및 시작") {
                        locationManager.start()
                        isMonitoring = true
                    }
                    .disabled(serverURL.isEmpty || deviceID.isEmpty || apiSecret.isEmpty || isMonitoring)
                }

                if isMonitoring {
                    Section {
                        Label("위치 변화 감지 중", systemImage: "location.fill")
                            .foregroundStyle(.green)
                    }
                }

                if !locationManager.history.isEmpty {
                    Section("최근 전송 이력") {
                        ForEach(locationManager.history) { entry in
                            VStack(alignment: .leading, spacing: 4) {
                                Text(dateFormatter.string(from: entry.timestamp))
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                Text(String(format: "%.6f, %.6f", entry.latitude, entry.longitude))
                                    .font(.system(.body, design: .monospaced))
                            }
                            .padding(.vertical, 2)
                        }
                    }
                }
            }
            .navigationTitle("Beacon")
        }
    }
}

#Preview {
    ContentView()
}
