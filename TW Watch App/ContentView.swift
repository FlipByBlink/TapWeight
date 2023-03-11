import SwiftUI

struct ContentView: View {
    @EnvironmentObject var 📱: 📱AppModel
    var body: some View {
        NavigationStack {
            List {
                🎚️BodyMassStepper()
                🪧BMIView()
                🎚️BodyFatStepper()
                🪧LBMView()
                👆DoneButton()
            }
            .modifier(🚨RegistrationErrorAlert())
            .onChange(of: 📱.🚩showResult) {
                if $0 == false { 📱.ⓒlearStates() }
            }
        }
    }
}
