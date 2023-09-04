import SwiftUI
import HealthKit

struct ContentView: View {
    @EnvironmentObject var 📱: 📱AppModel
    @Environment(\.scenePhase) var scenePhase
    var body: some View {
        NavigationStack {
            📋InputFields()
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        if 📱.🚩ableDatePicker { 👆RegisterButton(.toolbar) } // ☑️
                    }
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        💟OpenHealthAppButton.onMainView()
                        🛠MenuButton() // ⚙️
                    }
                }
        }
        .onChange(of: self.scenePhase) {
            if $0 == .active {
                📱.📝resetInputValues()
                📱.📅resetDatePickerValue()
            }
        }
        .modifier(🚨RegistrationErrorAlert())
        .modifier(🔐AuthManager())
        .modifier(🧩LayoutHandle())
        .modifier(📣ADSheet())
    }
}
