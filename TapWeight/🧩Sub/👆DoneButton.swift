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
    struct bottom: View {
        @EnvironmentObject var 📱: 📱AppModel
        var body: some View {
            if !📱.🚩ableDatePicker {
                👆DoneButton()
                    .background {
                        Circle()
                            .foregroundStyle(.background)
                    }
                    .font(.system(size: 120))
                    .padding()
            }
        }
    }
    struct onToolbar: ToolbarContent {
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
