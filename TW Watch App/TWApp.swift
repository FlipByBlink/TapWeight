import SwiftUI

@main
struct TW_Watch_App: App {
    @StateObject private var 📱 = 📱AppModel()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear { 📱.ⓢetup() }
                .modifier(🔐AuthManager())
                .environment(\.layoutDirection, .leftToRight)
                .environmentObject(📱)
        }
    }
}
