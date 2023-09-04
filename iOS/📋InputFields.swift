import SwiftUI

struct 📋InputFields: View {
    @EnvironmentObject var 📱: 📱AppModel
    @Environment(\.ⓛayout) var ⓛayout
    var body: some View {
        List {
            Section {
                🎚️BodyMassStepper()
                🪧BMIView()
            }
            🎚️BodyFatStepper()
            🪧LBMView()
            📅DatePicker()
        }
        .listStyle(.plain)
        .minimumScaleFactor(0.3)
        .navigationTitle("Body Mass")
        .navigationBarTitleDisplayMode(self.ⓛayout == .compact ? .inline : .large)
        .safeAreaInset(edge: .bottom) {
            if !📱.🚩ableDatePicker { 👆RegisterButton(.bottom) } // ☑️
        }
        .frame(maxWidth: 600)
    }
}
