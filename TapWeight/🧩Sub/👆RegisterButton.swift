import SwiftUI

struct 👆RegisterButton: View { // ☑️
    @EnvironmentObject var 📱: 📱AppModel
    private let ⓟosition: 🄿osition
    var body: some View {
        Button {
            📱.👆register()
        } label: {
            switch self.ⓟosition {
                case .bottom:
                    Image(systemName: "checkmark")
                        .font(.system(size: 56, weight: .heavy))
                        .foregroundColor(.white)
                        .padding(22)
                        .background {
                            Circle()
                                .foregroundColor(.pink)
                        }
                        .shadow(radius: 2.5)
                        .padding()
                case .toolbar:
                    Image(systemName: "checkmark.circle.fill")
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(.white, .pink)
                        .font(.title2.bold())
            }
        }
        .accessibilityLabel("Register")
        .fullScreenCover(isPresented: $📱.🚩showResult) { 🗯ResultView() }
    }
    init(_ ⓟosition: 🄿osition) {
        self.ⓟosition = ⓟosition
    }
    enum 🄿osition {
        case bottom, toolbar
    }
}
