
import SwiftUI
import HealthKit


@main
struct TapWeightApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .overlay(alignment: .bottomTrailing) {
                    MenuView()
                }
        }
    }
}
