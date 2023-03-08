import SwiftUI

@main
struct TW_Watch_App: App {
    @StateObject private var 📱 = 📱AppModel()
    @WKApplicationDelegateAdaptor(🅂yncDelegate.self) var ⓓelegate
    var body: some Scene {
        WindowGroup {
            ContentView()
                .task { 📱.ⓢetupOnLaunch() }
                .environment(\.layoutDirection, .leftToRight)
                .environmentObject(📱)
        }
    }
}
