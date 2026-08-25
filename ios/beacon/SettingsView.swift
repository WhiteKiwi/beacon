import SwiftUI

struct SettingsView: View {
    @AppStorage("serverURL") private var serverURL = ""
    @AppStorage("deviceID") private var deviceID = ""
    @State private var apiSecret = ""
    @Environment(\.dismiss) private var dismiss

    var body: some View {
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
        }
        .navigationTitle("설정")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            apiSecret = CredentialsStore.apiSecret
            AppAnalytics.screen("settings")
        }
        .onChange(of: apiSecret) { _, value in
            CredentialsStore.apiSecret = value
        }
    }
}
