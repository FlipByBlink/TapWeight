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
            .navigationTitle("Body Mass")
            .navigationBarTitleDisplayMode(.inline)
            .modifier(🚨RegistrationErrorAlert())
        }
        .headerProminence(.increased)
    }
}

struct ContentView_Previews: PreviewProvider {
    static let ⓜodel = 📱AppModel()
    static var previews: some View {
        ContentView()
            .environmentObject(self.ⓜodel)
    }
}
