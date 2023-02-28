import SwiftUI

@main
struct TapWeightApp: App {
    @StateObject private var 📱 = 📱AppModel()
    @StateObject private var 🛒 = 🛒StoreModel(id: "tapweight.adfree")
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .task {
                    📱.🏥checkAuthOnLaunch()
                    📱.observeChanges()
                }
                .modifier(📣ADSheet())
                .modifier(💬RequestUserReview())
                .environmentObject(📱)
                .environmentObject(🛒)
        }
    }
}
