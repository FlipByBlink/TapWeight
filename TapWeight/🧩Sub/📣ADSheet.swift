import SwiftUI

struct 📣ADSheet: ViewModifier {
    @EnvironmentObject var 🛒: 🛒StoreModel
    @Environment(\.scenePhase) var scenePhase
    @State private var ⓐpp: 📣MyApp = .pickUpAppWithout(.TapWeight)
    func body(content: Content) -> some View {
        content
            .sheet(isPresented: $🛒.🚩showADSheet) {
                📣ADView(self.ⓐpp, second: 7)
            }
            .onChange(of: self.scenePhase) {
                if $0 == .active {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        🛒.checkToShowADSheet()
                    }
                }
            }
    }
}
