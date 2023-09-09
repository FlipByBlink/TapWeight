import SwiftUI

struct 📣ADSheet: ViewModifier {
    @EnvironmentObject var 🛒: 🛒InAppPurchaseModel
    @State private var showSheet: Bool = false
    @State private var app: 📣ADTargetApp = .pickUpAppWithout(.TapWeight)
    func body(content: Content) -> some View {
        content
            .sheet(isPresented: self.$showSheet) {
                📣ADView(self.app, second: 10)
            }
            .onAppear {
                if 🛒.checkToShowADSheet() { self.showSheet = true }
            }
    }
}
