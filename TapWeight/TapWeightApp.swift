
import SwiftUI


@main
struct TapWeightApp: App {
    
    let 📱 = 📱Model()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .overlay(alignment: .bottomLeading) {
                    🛠MenuButton()
                }
                .overlay(alignment: .bottomTrailing) {
                    💟JumpButton()
                        .foregroundColor(.pink)
                }
                .environmentObject(📱)
        }
    }
}
