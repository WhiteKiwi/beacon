import SwiftUI

struct ContentView: View {
    @AppStorage("isActivated") private var isActivated = false

    var body: some View {
        if isActivated {
            HomeView()
        } else {
            SetupView()
        }
    }
}
