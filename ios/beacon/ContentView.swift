import SwiftUI

struct ContentView: View {
    @AppStorage("serverURL") private var serverURL = ""
    @AppStorage("deviceID") private var deviceID = ""
    @State private var isMonitoring = false

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
                }

                Section {
                    Button(isMonitoring ? "모니터링 중..." : "저장 및 시작") {
                        LocationManager.shared.start()
                        isMonitoring = true
                    }
                    .disabled(serverURL.isEmpty || deviceID.isEmpty || isMonitoring)
                }

                if isMonitoring {
                    Section {
                        Label("위치 변화 감지 중", systemImage: "location.fill")
                            .foregroundStyle(.green)
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
