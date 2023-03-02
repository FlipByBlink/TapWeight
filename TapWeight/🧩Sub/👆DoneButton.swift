import SwiftUI

struct 👆DoneButton: View { // ☑️
    @EnvironmentObject var 📱: 📱AppModel
    var body: some View {
        Button {
            📱.👆register()
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
        .fullScreenCover(isPresented: $📱.🚩showResult) {
            🗯ResultView()
        }
        .modifier(Self.🚨ErrorAlert())
    }
    private struct 🚨ErrorAlert: ViewModifier {
        @EnvironmentObject var 📱: 📱AppModel
        func body(content: Content) -> some View {
            content
                .alert("ERROR!", isPresented: $📱.🚩alertError) {
                    Link(destination: URL(string: "x-apple-health://")!) {
                        Label("Open \"Health\" app", systemImage: "app")
                    }
                } message: {
                    Text(📱.🚨registerationError?.message ?? "🐛")
                    switch 📱.🚨registerationError {
                        case .failedAuth(_):
                            Text("Please check permission on \"Health\" app")
                        default:
                            Text("🐛")
                    }
                }
        }
    }
}
