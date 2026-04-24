import SwiftUI

struct SetupView: View {
    @AppStorage("serverURL") private var serverURL = ""
    @AppStorage("deviceID") private var deviceID = ""
    @AppStorage("apiSecret") private var apiSecret = ""

    private var isFormValid: Bool {
        !serverURL.isEmpty && !deviceID.isEmpty && !apiSecret.isEmpty
    }

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
                    Button("시작하기") {
                        LocationManager.shared.start()
                    }
                    .disabled(!isFormValid)
                }
            }
            .navigationTitle("Beacon 설정")
        }
    }
}
