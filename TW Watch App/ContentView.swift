import SwiftUI

struct ContentView: View {
    @EnvironmentObject var 📱: 📱AppModel
    var body: some View {
        NavigationStack {
            List {
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
    }
}
