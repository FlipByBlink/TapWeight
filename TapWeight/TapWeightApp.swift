
import SwiftUI

@main
struct TapWeightApp: App {
    
    let 📱 = 📱Model()
    
    let 🏬 = 🏬Store()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(📱)
                .environmentObject(🏬)
        }
    }
}
