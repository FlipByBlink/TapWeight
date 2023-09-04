import SwiftUI

struct 📋InputFields: View {
    @EnvironmentObject var 📱: 📱AppModel
    @Environment(\.ⓛayout) var ⓛayout
    var body: some View {
        HStack {
            if self.ⓛayout == .sideBySide { Spacer(minLength: 24) }
            List {
                Section {
                    🎚️BodyMassStepper()
                    🪧BMIView()
                }
                🎚️BodyFatStepper()
                🪧LBMView()
                if self.ⓛayout != .sideBySide { 📅DatePicker() }
            }
            .listStyle(.plain)
            .minimumScaleFactor(0.3)
            .navigationTitle("Body Mass")
            .navigationBarTitleDisplayMode(self.ⓛayout == .compact ? .inline : .large)
            .frame(maxWidth: 600)
            if self.ⓛayout == .sideBySide {
                Spacer()
                📅DatePicker()
                Spacer()
            }
        }
        .safeAreaInset(edge: .bottom) {
            if self.ⓛayout != .compact { 👆RegisterButton(.bottom) } // ☑️
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                if self.ⓛayout == .compact { 👆RegisterButton(.toolbar) } // ☑️
            }
        }
    }
}
