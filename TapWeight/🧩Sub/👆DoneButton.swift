import SwiftUI

struct 👆DoneButton: View { // ☑️
    @EnvironmentObject var 📱: 📱AppModel
    @Environment(\.scenePhase) var scenePhase
    @State private var 🚩showResult: Bool = false
    var body: some View {
        Button {
            Task {
                await 📱.👆register()
                self.🚩showResult = true
            }
        } label: {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 120))
                .symbolRenderingMode(.palette)
                .foregroundStyle(.white, .pink)
        }
        .background {
            Circle()
                .foregroundStyle(.background)
        }
        .accessibilityLabel("DONE")
        .padding()
        .fullScreenCover(isPresented: self.$🚩showResult) {
            🗯ResultView()
        }
        .onChange(of: self.scenePhase) {
            if $0 == .background {
                self.🚩showResult = false
                📱.📝resetPickerValues()
            }
        }
    }
}
