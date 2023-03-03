import SwiftUI
import HealthKit

struct ContentView: View {
    @EnvironmentObject var 📱: 📱AppModel
    @Environment(\.scenePhase) var scenePhase
    var body: some View {
        if #available(iOS 16.0, *) {
            NavigationStack { self.ⓒontent() }
        } else {
            NavigationView { self.ⓒontent() }
        }
    }
    private func ⓒontent() -> some View {
        List {
            Section {
                🎚️BodyMassStepper()
                🪧BMIView()
            }
            🎚️BodyFatStepper()
            📅DatePicker()
        }
        .listStyle(.plain)
        .minimumScaleFactor(0.3)
        .navigationTitle("Body Mass")
        .safeAreaInset(edge: .bottom) {
            if !📱.🚩ableDatePicker { 👆DoneButton.onBottom() } // ☑️
        }
        .modifier(🚨RegistrationErrorAlert())
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                if 📱.🚩ableDatePicker { 👆DoneButton.onToolbar() } // ☑️
            }
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                💟OpenHealthAppButton.onMainView()
                🛠MenuButton() // ⚙️
            }
        }
        .onChange(of: self.scenePhase) { _ in
            📱.📝resetInputValues()
        }
    }
}
