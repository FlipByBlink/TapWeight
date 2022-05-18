
import SwiftUI
import HealthKit


@main
struct TapWeightApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .overlay(alignment: .bottomLeading) {
                    MenuView()
                        .padding(24)
                }
                .overlay(alignment: .bottomTrailing) {
                    Link(destination: URL(string: "x-apple-health://")!) {
                        Image(systemName: "app")
                            .imageScale(.large)
                            .overlay {
                                Image(systemName: "heart")
                                    .imageScale(.small)
                            }
                    }
                    .font(.largeTitle)
                    .foregroundStyle(.secondary)
                    .foregroundColor(.pink)
                    .padding(24)
                }
        }
    }
}
