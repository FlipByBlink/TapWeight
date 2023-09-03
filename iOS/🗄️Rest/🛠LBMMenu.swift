import SwiftUI

struct 🛠LBMMenu: View {
    @EnvironmentObject var 📱: 📱AppModel
    var body: some View {
        List {
            Section {
                Toggle(isOn: $📱.🚩ableLBM) {
                    Label("Lean Body Mass", systemImage: "person.badge.minus")
                }
                .disabled(!📱.🚩ableBodyFat)
                .onChange(of: 📱.🚩ableLBM) {
                    if $0 == true { 📱.🚩ableBodyFat = true }
                }
            } header: {
                Text("Option")
            } footer: {
                if !📱.🚩ableBodyFat {
                    Text("⚠️ Required: ")
                    +
                    Text("Body Fat Percentage")
                }
            }
            Section {
                ZStack {
                    Color.clear
                    Text(self.ⓕomulaDescription)
                        .multilineTextAlignment(.trailing)
                }
                .padding(8)
            } header: {
                Text("Formula")
            }
        }
        .navigationTitle("Lean Body Mass")
    }
    private var ⓕomulaDescription: String {
        String(localized: "Body Mass")
        +
        " - ("
        +
        String(localized: "Body Mass")
        +
        " × "
        +
        String(localized: "Body Fat Percentage")
        +
        ")"
    }
}
