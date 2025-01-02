import SwiftUI

struct 🔐AuthManager: ViewModifier {
    @EnvironmentObject private var 📱: 📱AppModel
    func body(content: Content) -> some View {
        content
            .onAppear { 📱.ⓢuggestAuthRequest(toShare: [.bodyMass], read: [.bodyMass]) }
            .onChange(of: 📱.🚩ableBMI) { _, newValue in
                if newValue == true { 📱.ⓢuggestAuthRequest(toShare: [.bodyMassIndex], read: [.bodyMassIndex, .height]) }
            }
            .onChange(of: 📱.🚩ableBodyFat) { _, newValue in
                if newValue == true { 📱.ⓢuggestAuthRequest(toShare: [.bodyFatPercentage], read: [.bodyFatPercentage]) }
            }
            .onChange(of: 📱.🚩ableLBM) { _, newValue in
                if newValue == true { 📱.ⓢuggestAuthRequest(toShare: [.leanBodyMass], read: [.leanBodyMass]) }
            }
    }
}
