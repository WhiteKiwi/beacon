import SwiftUI

struct HomeView: View {
    @ObservedObject private var locationManager = LocationManager.shared
    @State private var isSending = false
    @State private var errorMessage: String? = nil

    private let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "MM/dd HH:mm:ss"
        return f
    }()

    var body: some View {
        NavigationStack {
            Group {
                if locationManager.history.isEmpty {
                    ContentUnavailableView(
                        "전송 이력 없음",
                        systemImage: "location.slash",
                        description: Text("위치가 크게 변경되거나 수동 전송하면 이력이 쌓입니다.")
                    )
                } else {
                    List(locationManager.history) { entry in
                        HStack(spacing: 12) {
                            Image(systemName: entry.success ? "checkmark.circle.fill" : "xmark.circle.fill")
                                .foregroundStyle(entry.success ? .green : .red)
                            VStack(alignment: .leading, spacing: 4) {
                                Text(dateFormatter.string(from: entry.timestamp))
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                Text(String(format: "%.6f, %.6f", entry.latitude, entry.longitude))
                                    .font(.system(.body, design: .monospaced))
                            }
                        }
                        .padding(.vertical, 2)
                    }
                }
            }
            .navigationTitle("Beacon")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        sendManually()
                    } label: {
                        if isSending {
                            ProgressView()
                        } else {
                            Image(systemName: "paperplane")
                        }
                    }
                    .disabled(isSending)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink(destination: SettingsView()) {
                        Image(systemName: "gear")
                    }
                }
            }
            .alert("전송 실패", isPresented: .init(
                get: { errorMessage != nil },
                set: { if !$0 { errorMessage = nil } }
            )) {
                Button("확인", role: .cancel) {}
            } message: {
                Text(errorMessage ?? "")
            }
        }
        .onAppear {
            AppAnalytics.screen("home")
            LocationManager.shared.start()
        }
    }

    private func sendManually() {
        isSending = true
        LocationManager.shared.sendManually { error in
            AppAnalytics.log(
                "manual_location_send",
                parameters: ["result": error == nil ? "success" : "failure"]
            )
            isSending = false
            errorMessage = error
        }
    }
}
