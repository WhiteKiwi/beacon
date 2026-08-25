import SwiftUI

struct SettingsView: View {
    @AppStorage("serverURL") private var serverURL = ""
    @AppStorage("deviceID") private var deviceID = ""
    @AppStorage("analyticsEnabled") private var analyticsEnabled = false
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

            Section("개인정보") {
                Toggle("익명 사용 분석 허용", isOn: $analyticsEnabled)
                Link(
                    "개인정보 처리방침",
                    destination: URL(string: "https://github.com/WhiteKiwi/beacon/blob/main/PRIVACY.md")!
                )
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
        .onChange(of: analyticsEnabled) { _, value in
            AppAnalytics.setCollectionEnabled(value)
        }
    }
}
