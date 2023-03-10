import SwiftUI

@main
struct TW_Watch_App: App {
    @WKApplicationDelegateAdaptor var 📱: 📱AppModel
    var body: some Scene {
        WindowGroup {
            ContentView()
                .task { 📱.ⓢetupOnLaunch() }
                .environment(\.layoutDirection, .leftToRight)
        }
    }
}
