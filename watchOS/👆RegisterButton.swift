import SwiftUI

struct 👆RegisterButton: View { // ☑️
    @EnvironmentObject var 📱: 📱AppModel
    var body: some View {
        Button {
            📱.👆register()
        } label: {
            Label("Register", systemImage: "checkmark")
        }
        .listItemTint(.pink)
        .foregroundStyle(.white)
        .fontWeight(.semibold)
        .modifier(🚨RegistrationErrorAlert())
        .fullScreenCover(isPresented: $📱.🚩showResult) { 🗯ResultView() }
        .onChange(of: 📱.🚩showResult) {
            if $0 == false { 📱.ⓒlearStates() }
        }
    }
}
