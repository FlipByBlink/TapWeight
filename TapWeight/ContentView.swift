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
            .toolbar { 🛠MenuButton() } // ⚙️
            .safeAreaInset(edge: .bottom) {
                HStack(alignment: .firstTextBaseline) {
                    👆DoneButton() // ☑️
                    Spacer()
                    💟JumpButton()
                }
            }
        }
        .onChange(of: self.scenePhase) {
            if $0 == .background { 📱.📝resetInputValues() }
        }
    }
}
