import SwiftUI

struct 🔐AuthManager: ViewModifier {
    @EnvironmentObject private var 📱: 📱AppModel
    func body(content: Content) -> some View {
        content
            .onAppear { 📱.ⓢuggestAuthRequest(toShare: [.bodyMass], read: [.bodyMass]) }
            .onChange(of: 📱.🚩ableBMI) {
                if $0 == true { 📱.ⓢuggestAuthRequest(toShare: [.bodyMassIndex], read: [.bodyMassIndex, .height]) }
            }
            .onChange(of: 📱.🚩ableBodyFat) {
                if $0 == true { 📱.ⓢuggestAuthRequest(toShare: [.bodyFatPercentage], read: [.bodyFatPercentage]) }
            }
            .onChange(of: 📱.🚩ableLBM) {
                if $0 == true { 📱.ⓢuggestAuthRequest(toShare: [.leanBodyMass], read: [.leanBodyMass]) }
            }
    }
}
