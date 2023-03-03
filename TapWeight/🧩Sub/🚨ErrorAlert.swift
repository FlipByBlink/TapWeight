import SwiftUI

struct 🚨RegistrationErrorAlert: ViewModifier {
    @EnvironmentObject var 📱: 📱AppModel
    func body(content: Content) -> some View {
        content
            .alert("⚠️ Failed registration", isPresented: $📱.🚩alertRegistrationError) {
                Link(destination: URL(string: "x-apple-health://")!) {
                    Label("Open \"Health\" app", systemImage: "app")
                }
            } message: {
                Text(📱.🚨registrationError?.message ?? "🐛")
                switch 📱.🚨registrationError {
                    case .failedAuth(_):
                        Text("Please check permission on \"Health\" app")
                    default:
                        Text("🐛")
                }
            }
    }
}

struct 🚨CancellationErrorAlert: ViewModifier {
    @EnvironmentObject var 📱: 📱AppModel
    func body(content: Content) -> some View {
        content
            .alert("⚠️ Failed cancellation", isPresented: $📱.🚩alertCancellationError) {
                EmptyView()
            } message: {
                Text(📱.🚨cancellationError?.message ?? "🐛")
            }
    }
}
