import SwiftUI
import WatchConnectivity

struct 🅂yncOptions: ViewModifier {
    @EnvironmentObject var 📱: 📱AppModel
    func body(content: Content) -> some View {
        content
            .onChange(of: 📱.🚩amount50g) { _ in self.ⓢync() }
            .onChange(of: 📱.🚩ableBMI) { _ in self.ⓢync() }
            .onChange(of: 📱.🚩ableBodyFat) { _ in self.ⓢync() }
            .onChange(of: 📱.🚩ableLBM) { _ in self.ⓢync() }
            .task { self.ⓢync() }
    }
    private func ⓢync() {
        do {
            try WCSession.default.updateApplicationContext(["Amount50g": 📱.🚩amount50g,
                                                            "AbleBMI": 📱.🚩ableBMI,
                                                            "AbleBodyFat": 📱.🚩ableBodyFat,
                                                            "AbleLBM": 📱.🚩ableLBM,])
        } catch {
            print("🚨", error.localizedDescription)
        }
    }
}
