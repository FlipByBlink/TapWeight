import SwiftUI
import HealthKit

struct ContentView: View {
    @EnvironmentObject var 📱: 📱AppModel
    @Environment(\.scenePhase) var scenePhase
    var body: some View {
        NavigationView {
            List {
                Section {
                    🎚️BodyMassStepper()
                    if 📱.🚩ableBMI { 🪧BMIView() }
                }
                if 📱.🚩ableBodyFat { 🎚️BodyFatStepper() }
                📅DatePicker()
                    .padding(.top, 12)
            }
            .listStyle(.plain)
            .minimumScaleFactor(0.3)
            .navigationTitle("Body Mass")
            .toolbar {
                self.ⓙumpButton()
                🛠MenuButton() // ⚙️
            }
            .safeAreaInset(edge: .bottom) { 👆DoneButton() } // ☑️
        }
        .onChange(of: self.scenePhase) { _ in
            📱.📝resetInputValues()
        }
    }
    private func ⓙumpButton() -> some View {
        💟JumpButton()
            .font(.title2)
            .foregroundColor(.primary)
    }
}
