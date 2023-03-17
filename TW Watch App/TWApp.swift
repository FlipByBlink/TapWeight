import SwiftUI

@main
struct TW_Watch_App: App {
    @WKApplicationDelegateAdaptor var 📱: 📱AppModel
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modifier(🄰uthManager())
                .environment(\.layoutDirection, .leftToRight)
        }
    }
}
