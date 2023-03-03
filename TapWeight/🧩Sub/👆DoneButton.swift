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
        }
        .accessibilityLabel("DONE")
        .fullScreenCover(isPresented: $📱.🚩showResult) { 🗯ResultView() }
    }
    static func bottom() -> some View {
        Self()
            .background {
                Circle()
                    .foregroundStyle(.background)
            }
            .font(.system(size: 120))
            .padding()
    }
    struct toolbar: ToolbarContent {
        @EnvironmentObject var 📱: 📱AppModel
        var body: some ToolbarContent {
            ToolbarItem(placement: .navigationBarLeading) {
                if 📱.🚩ableDatePicker {
                    👆DoneButton()
                        .font(.title2.bold())
                }
            }
        }
    }
}
