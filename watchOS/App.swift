import SwiftUI

@main
struct watchOSApp: App {
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
