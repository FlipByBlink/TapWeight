
import SwiftUI


@main
struct TapWeightApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .overlay(alignment: .bottomLeading) {
                    🛠Menu()
                }
                .overlay(alignment: .bottomTrailing) {
                    💟JumpButton()
                        .foregroundColor(.pink)
                }
        }
    }
}
