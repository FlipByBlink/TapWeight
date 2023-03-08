import SwiftUI

@main
struct TW_Watch_App: App {
    @StateObject private var 📱 = 📱AppModel()
    @WKApplicationDelegateAdaptor(🅂yncDelegate.self) var ⓓelegate
    var body: some Scene {
        WindowGroup {
            ContentView()
                .task { 📱.ⓢetupOnLaunch() }
                .task {
                    📱.ⓡequestAuth([.bodyMassIndex, .bodyFatPercentage, .leanBodyMass])
                    📱.🚩ableBMI = true
                    📱.🚩ableBodyFat = true
                    📱.🚩ableLBM = true
                } //TODO: 適切に実装し直す
                .environment(\.layoutDirection, .leftToRight)
                .environmentObject(📱)
        }
    }
}
