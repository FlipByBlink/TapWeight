
import SwiftUI

@main
struct TapWeightApp: App {
    
    let 📱 = 📱AppModel()
    
    let 🏬 = 🏬StoreModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(📱)
                .environmentObject(🏬)
        }
    }
}
