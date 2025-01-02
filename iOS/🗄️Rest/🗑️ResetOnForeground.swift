import SwiftUI

struct 🗑️ResetOnForeground: ViewModifier {
    @EnvironmentObject var 📱: 📱AppModel
    @Environment(\.scenePhase) var scenePhase
    func body(content: Content) -> some View {
        content
            .onChange(of: self.scenePhase) { _, newValue in
                if newValue == .active {
                    📱.📝resetInputValues()
                    📱.📅resetDatePickerValue()
                }
            }
    }
}
