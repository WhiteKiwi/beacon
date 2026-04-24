import SwiftUI

struct HomeView: View {
    @ObservedObject private var locationManager = LocationManager.shared

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
                        description: Text("위치가 크게 변경되면 이력이 쌓입니다.")
                    )
                } else {
                    List(locationManager.history) { entry in
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
            .navigationTitle("Beacon")
            .toolbar {
                NavigationLink(destination: SettingsView()) {
                    Image(systemName: "gear")
                }
            }
        }
        .onAppear {
            LocationManager.shared.start()
        }
    }
}
