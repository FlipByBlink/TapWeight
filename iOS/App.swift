import SwiftUI

@main
struct iOSApp: App {
    @UIApplicationDelegateAdaptor var 📱: 📱AppModel
    @StateObject private var 🛒 = 🛒InAppPurchaseModel(id: "tapweight.adfree")
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(🛒)
        }
    }
}
