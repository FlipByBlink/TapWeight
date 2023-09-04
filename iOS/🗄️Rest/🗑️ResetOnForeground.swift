import SwiftUI

struct 🗑️ResetOnForeground: ViewModifier {
    @EnvironmentObject var 📱: 📱AppModel
    @Environment(\.scenePhase) var scenePhase
    func body(content: Content) -> some View {
        content
            .onChange(of: self.scenePhase) {
                if $0 == .active {
                    📱.📝resetInputValues()
                    📱.📅resetDatePickerValue()
                }
            }
    }
}
