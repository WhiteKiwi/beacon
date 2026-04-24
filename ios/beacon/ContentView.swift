import SwiftUI

struct ContentView: View {
    @AppStorage("serverURL") private var serverURL = ""
    @AppStorage("deviceID") private var deviceID = ""
    @AppStorage("apiSecret") private var apiSecret = ""

    private var isSetupComplete: Bool {
        !serverURL.isEmpty && !deviceID.isEmpty && !apiSecret.isEmpty
    }

    var body: some View {
        if isSetupComplete {
            HomeView()
        } else {
            SetupView()
        }
    }
}
