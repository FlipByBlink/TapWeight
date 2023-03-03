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
                .padding(.top, 12)
        }
        .listStyle(.plain)
        .minimumScaleFactor(0.3)
        .navigationTitle("Body Mass")
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                self.ⓞpenHealthAppButton()
                🛠MenuButton() // ⚙️
            }
        }
        .safeAreaInset(edge: .bottom) { 👆DoneButton() } // ☑️
        .onChange(of: self.scenePhase) { _ in
            📱.📝resetInputValues()
        }
    }
    private func ⓞpenHealthAppButton() -> some View {
        💟OpenHealthAppButton()
            .font(.title2)
            .foregroundColor(.primary)
    }
}
