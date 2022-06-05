
import SwiftUI

@main
struct TapWeightApp: App {
    
    let 📱 = 📱Model()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(📱)
        }
    }
}
