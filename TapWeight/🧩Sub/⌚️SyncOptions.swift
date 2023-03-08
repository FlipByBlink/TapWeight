import SwiftUI

struct 🅂yncOptions: ViewModifier {
    @EnvironmentObject var ⓓelegate: 🅂yncDelegate
    @EnvironmentObject var 📱: 📱AppModel
    func body(content: Content) -> some View {
        content
            .onChange(of: 📱.🚩amount50g) { _ in ⓓelegate.ⓢync() }
            .onChange(of: 📱.🚩ableBMI) { _ in ⓓelegate.ⓢync() }
            .onChange(of: 📱.🚩ableBodyFat) { _ in ⓓelegate.ⓢync() }
            .onChange(of: 📱.🚩ableLBM) { _ in ⓓelegate.ⓢync() }
            .task { ⓓelegate.ⓢync() }
    }
}
