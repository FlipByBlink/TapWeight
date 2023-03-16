import SwiftUI

struct ContentView: View {
    @EnvironmentObject var 📱: 📱AppModel
    var body: some View {
        NavigationStack {
            List {
                Section {
                    🎚️BodyMassStepper()
                    🪧BMIView()
                } header: {
                    Text("Body Mass")
                        .bold()
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
            .modifier(🚨RegistrationErrorAlert())
            .onChange(of: 📱.🚩showResult) {
                if $0 == false { 📱.ⓒlearStates() }
            }
        }
    }
}
