
import SwiftUI
import HealthKit


@main
struct TapWeightApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .overlay(alignment: .bottomLeading) {
                    🛠Menu()
                        .padding(24)
                }
                .overlay(alignment: .bottomTrailing) {
                    💟JumpButton()
                        .foregroundColor(.pink)
                }
        }
    }
}
