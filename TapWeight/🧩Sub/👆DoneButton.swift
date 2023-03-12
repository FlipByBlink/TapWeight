import SwiftUI

struct 👆DoneButton: View { // ☑️
    @EnvironmentObject var 📱: 📱AppModel
    var body: some View {
        Button {
            📱.👆register()
        } label: {
            Image(systemName: "checkmark.circle.fill")
                .symbolRenderingMode(.palette)
                .foregroundStyle(.white, .pink)
                .shadow(radius: 4)
        }
        .accessibilityLabel("DONE")
        .fullScreenCover(isPresented: $📱.🚩showResult) { 🗯ResultView() }
    }
    static func onBottom() -> some View {
        👆DoneButton()
            .font(.system(size: 120))
            .padding()
    }
    static func onToolbar() -> some View {
        👆DoneButton()
            .font(.title2.bold())
    }
}
