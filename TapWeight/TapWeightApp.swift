import SwiftUI

@main
struct TapWeightApp: App {
    @StateObject private var 📱 = 📱AppModel()
    @StateObject private var 🛒 = 🛒StoreModel(id: "tapweight.adfree")
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear { 📱.🏥checkAuthOnLaunch() }
                .onAppear { 📱.🏥getLatestValue() }
                .environmentObject(📱)
                .environmentObject(🛒)
        }
    }
}
