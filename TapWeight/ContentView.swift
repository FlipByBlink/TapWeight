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
                if 📱.🚩ableBMI { 🪧BMIView() }
            }
            if 📱.🚩ableBodyFat { 🎚️BodyFatStepper() }
            📅DatePicker()
        }
        .listStyle(.plain)
        .minimumScaleFactor(0.3)
        .navigationTitle("Body Mass")
        .safeAreaInset(edge: .bottom) { self.👆doneBottomButton() } // ☑️
        .modifier(🚨RegistrationErrorAlert())
        .toolbar {
            self.👆doneToolbarButton()
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                self.💟openHealthAppButton()
                🛠MenuButton() // ⚙️
            }
        }
        .onChange(of: self.scenePhase) { _ in
            📱.📝resetInputValues()
        }
    }
    private func 👆doneBottomButton() -> some View {
        Group {
            if !📱.🚩ableDatePicker {
                👆DoneButton()
                    .background {
                        Circle().foregroundStyle(.background)
                    }
                    .font(.system(size: 120))
                    .padding()
            }
        }
    }
    private func 👆doneToolbarButton() -> some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            if 📱.🚩ableDatePicker {
                👆DoneButton()
                    .font(.title2.bold())
            }
        }
    }
    private func 💟openHealthAppButton() -> some View {
        💟OpenHealthAppButton()
            .font(.title2)
            .foregroundColor(.primary)
    }
}
