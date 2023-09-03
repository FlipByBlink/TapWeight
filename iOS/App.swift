import SwiftUI

@main
struct iOSApp: App {
    @UIApplicationDelegateAdaptor var 📱: 📱AppModel
    @StateObject private var 🛒 = 🛒StoreModel(id: "tapweight.adfree")
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modifier(🔐AuthManager())
                .modifier(📣ADSheet())
                .environmentObject(🛒)
        }
    }
}
