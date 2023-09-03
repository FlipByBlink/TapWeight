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
                    if 📱.🚩ableBMI { 🪧BMIView() }
                }
                if 📱.🚩ableBodyFat {
                    Section {
                        🎚️BodyFatStepper()
                        if 📱.🚩ableLBM { 🪧LBMView() }
                    } header: {
                        Text("Body Fat Percentage")
                            .bold()
                    }
                }
                👆RegisterButton()
            }
            .navigationTitle("Body Mass")
            .navigationBarTitleDisplayMode(.inline)
        }
        .modifier(🔐AuthManager())
        .environment(\.layoutDirection, .leftToRight)
        .task {
            try? await Task.sleep(for: .seconds(1.5))
            withAnimation { self.🚩hideErrorMessage = false }
        }
    }
}
