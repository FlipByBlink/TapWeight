import SwiftUI

struct 🔐AuthManager: ViewModifier {
    @EnvironmentObject var 📱: 📱AppModel
    func body(content: Content) -> some View {
        content
            .onAppear { 📱.ⓡequestAuths() }
            .onChange(of: [📱.🚩ableBMI, 📱.🚩ableBodyFat, 📱.🚩ableLBM]) { _ in
                📱.ⓡequestAuths()
            }
    }
}
