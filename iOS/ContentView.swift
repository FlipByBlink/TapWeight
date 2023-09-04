import SwiftUI
import HealthKit

struct ContentView: View {
    @EnvironmentObject var 📱: 📱AppModel
    @Environment(\.scenePhase) var scenePhase
    var body: some View {
        NavigationStack {
            List {
                Section {
                    🎚️BodyMassStepper()
                    🪧BMIView()
                }
                🎚️BodyFatStepper()
                🪧LBMView()
                📅DatePicker()
            }
            .listStyle(.plain)
            .minimumScaleFactor(0.3)
            .navigationTitle("Body Mass")
            .safeAreaInset(edge: .bottom) {
                if !📱.🚩ableDatePicker { 👆RegisterButton(.bottom) } // ☑️
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    if 📱.🚩ableDatePicker { 👆RegisterButton(.toolbar) } // ☑️
                }
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    💟OpenHealthAppButton.onMainView()
                    🛠MenuButton() // ⚙️
                }
            }
            .frame(maxWidth: 600)
        }
        .onChange(of: self.scenePhase) {
            if $0 == .active {
                📱.📝resetInputValues()
                📱.📅resetDatePickerValue()
            }
        }
        .modifier(🚨RegistrationErrorAlert())
        .modifier(🔐AuthManager())
        .modifier(📣ADSheet())
    }
}
