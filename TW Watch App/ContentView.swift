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
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static let ⓜodel = 📱AppModel()
    static var previews: some View {
        ContentView()
            .environmentObject(self.ⓜodel)
    }
}
