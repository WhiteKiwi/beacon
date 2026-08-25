import SwiftUI

struct SetupView: View {
    @AppStorage("serverURL") private var serverURL = ""
    @AppStorage("deviceID") private var deviceID = ""
    @AppStorage("isActivated") private var isActivated = false
    @State private var apiSecret = ""

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
                        CredentialsStore.apiSecret = apiSecret
                        AppAnalytics.log("setup_completed")
                        LocationManager.shared.start()
                        isActivated = true
                    }
                    .disabled(!isFormValid)
                }

                Section("위치 권한") {
                    Text("백그라운드에서도 중요한 위치 변경을 전송하려면 다음 단계에서 위치 접근을 ‘항상 허용’으로 선택해 주세요.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("Beacon 설정")
        }
        .onAppear {
            apiSecret = CredentialsStore.apiSecret
            AppAnalytics.screen("setup")
        }
    }
}
