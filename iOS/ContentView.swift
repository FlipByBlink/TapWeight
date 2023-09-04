import SwiftUI
import HealthKit

struct ContentView: View {
    @EnvironmentObject var 📱: 📱AppModel
    var body: some View {
        NavigationStack {
            📋InputFields()
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        💟OpenHealthAppButton.onMainView()
                        🛠MenuButton() // ⚙️
                    }
                }
        }
        .modifier(🗑️ResetOnForeground())
        .modifier(🚨RegistrationErrorAlert())
        .modifier(🔐AuthManager())
        .modifier(🧩LayoutHandle())
        .modifier(📣ADSheet())
    }
}
