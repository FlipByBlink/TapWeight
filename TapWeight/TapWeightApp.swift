import SwiftUI

@main
struct TapWeightApp: App {
    @StateObject private var 🛒 = 🛒StoreModel(id: "tapweight.adfree")
    @UIApplicationDelegateAdaptor var 📱: 📱AppModel
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modifier(🔐AuthManager())
                .modifier(📣ADSheet())
                .environmentObject(🛒)
        }
    }
}
