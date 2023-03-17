import SwiftUI

struct ContentView: View {
    @EnvironmentObject var 📱: 📱AppModel
    @State private var 🚩hideErrorMessage: Bool = true
    var body: some View {
        NavigationStack {
            List {
                if !self.🚩hideErrorMessage { 🚨ErrorMessage() }
                Section {
                    🎚️BodyMassStepper()
                    🪧BMIView()
                }
                if 📱.🚩ableBodyFat {
                    Section {
                        🎚️BodyFatStepper()
                        🪧LBMView()
                    } header: {
                        Text("Body Fat Percentage")
                            .bold()
                    }
                }
                👆DoneButton()
            }
            .navigationTitle("Body Mass")
            .navigationBarTitleDisplayMode(.inline)
            .modifier(🚨RegistrationErrorAlert())
            .onChange(of: 📱.🚩showResult) {
                if $0 == false { 📱.ⓒlearStates() }
            }
        }
        .task {
            try? await Task.sleep(for: .seconds(1.5))
            withAnimation { self.🚩hideErrorMessage = false }
        }
    }
}
