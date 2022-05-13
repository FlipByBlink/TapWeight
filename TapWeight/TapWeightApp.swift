
import SwiftUI
import HealthKit


@main
struct TapWeightApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .statusBar(hidden: true)
                .overlay(alignment: .bottomTrailing) {
                    MenuButton()
                }
        }
    }
}


enum 🄴numUnit: String, CaseIterable {
    case kg
    case lbs
    case st
}
