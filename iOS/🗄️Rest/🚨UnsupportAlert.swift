import SwiftUI
import HealthKit

struct 🚨UnsupportAlert: ViewModifier {
    @State private var alert: Bool = false
    func body(content: Content) -> some View {
        content
            .task {
                if !HKHealthStore.isHealthDataAvailable() {
                    self.alert = true
                }
            }
            .alert("Sorry", isPresented: self.$alert) {
                EmptyView()
            } message: {
                Text(self.message)
            }
    }
    private var message: LocalizedStringKey {
        if UIDevice.current.userInterfaceIdiom == .pad {
            #"Unfortunately, this device is not compatible. iPad support "Health" app from iPadOS 17.0."#
        } else {
            "Unfortunately, this device is not compatible."
        }
    }
}
