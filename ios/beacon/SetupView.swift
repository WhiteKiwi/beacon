import SwiftUI

struct SetupView: View {
    @AppStorage("serverURL") private var serverURL = ""
    @AppStorage("deviceID") private var deviceID = ""
    @AppStorage("isActivated") private var isActivated = false
    @AppStorage("analyticsEnabled") private var analyticsEnabled = false
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

                Section("개인정보") {
                    Toggle("익명 사용 분석 허용", isOn: $analyticsEnabled)
                    Text("허용하면 앱 실행과 화면 사용 같은 익명 통계를 Firebase Analytics로 전송합니다. 정확한 위치와 서버 설정은 분석에 포함하지 않습니다.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                    Link(
                        "개인정보 처리방침",
                        destination: URL(string: "https://github.com/WhiteKiwi/beacon/blob/main/PRIVACY.md")!
                    )
                }

                Section {
                    Button("시작하기") {
                        CredentialsStore.apiSecret = apiSecret
                        AppAnalytics.setCollectionEnabled(analyticsEnabled)
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
        .onChange(of: analyticsEnabled) { _, value in
            AppAnalytics.setCollectionEnabled(value)
        }
    }
}
