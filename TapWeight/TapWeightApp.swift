import SwiftUI

@main
struct TapWeightApp: App {
    @StateObject private var 📱 = 📱AppModel()
    @StateObject private var 🛒 = 🛒StoreModel(id: "tapweight.adfree")
    @UIApplicationDelegateAdaptor(🄰ppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .task { 📱.ⓢetupOnLaunch() }
                .modifier(📣ADSheet())
                .environmentObject(📱)
                .environmentObject(🛒)
        }
    }
}

class 🄰ppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        return true
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        [.banner, .list, .badge, .sound]
    }
}
