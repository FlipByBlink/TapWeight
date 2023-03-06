import SwiftUI

@main
struct TapWeightApp: App {
    @StateObject private var 📱 = 📱AppModel()
    @StateObject private var 🛒 = 🛒StoreModel(id: "tapweight.adfree")
    @UIApplicationDelegateAdaptor(🄰ppDelegate.self) var ⓐppDelegate
    @UIApplicationDelegateAdaptor(🅂yncDelegate.self) var ⓢceneDelegate
    
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
