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
            ToolbarItem(placement: .navigationBarLeading) {
                if 📱.🚩ableDatePicker { self.ⓓoneToolbarButton() }
            }
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                self.ⓞpenHealthAppButton()
                🛠MenuButton() // ⚙️
            }
        }
        .safeAreaInset(edge: .bottom) {
            if !📱.🚩ableDatePicker { self.ⓓoneBottomButton() } // ☑️
        }
        .onChange(of: self.scenePhase) { _ in
            📱.📝resetInputValues()
        }
    }
    private func ⓓoneBottomButton() -> some View {
            👆DoneButton()
                .background {
                    Circle().foregroundStyle(.background)
                }
                .font(.system(size: 120))
                .padding()
    }
    private func ⓓoneToolbarButton() -> some View {
            👆DoneButton()
                .font(.title2.bold())
    }
    private func ⓞpenHealthAppButton() -> some View {
        💟OpenHealthAppButton()
            .font(.title2)
            .foregroundColor(.primary)
    }
}
