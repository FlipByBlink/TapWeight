import SwiftUI
import HealthKit

struct ContentView: View {
    @EnvironmentObject var 📱: 📱AppModel
    @Environment(\.scenePhase) var scenePhase
    var body: some View {
        if #available(iOS 16.0, *) {
            NavigationStack { self.ⓒontent() }
        } else {
            NavigationView { self.ⓒontent() }
        }
    }
    private func ⓒontent() -> some View {
        List {
            Button("REMOVE badge") {
                let content = UNMutableNotificationContent()
                content.badge = 1
                let request = UNNotificationRequest(identifier: "badge now",
                                                    content: content,
                                                    trigger: nil)
                UNUserNotificationCenter.current().add(request)
//                UNUserNotificationCenter.current().removeAllDeliveredNotifications()
//                UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                UNUserNotificationCenter.current().getPendingNotificationRequests { a in
                    print(a.debugDescription)
                }
                UNUserNotificationCenter.current().getDeliveredNotifications { a in
                    print(a.debugDescription)
                }
                
            }
            Section {
                🎚️BodyMassStepper()
                🪧BMIView()
            }
            🎚️BodyFatStepper()
            🪧LBMView()
            📅DatePicker()
        }
        .listStyle(.plain)
        .minimumScaleFactor(0.3)
        .navigationTitle("Body Mass")
        .safeAreaInset(edge: .bottom) {
            if !📱.🚩ableDatePicker { 👆DoneButton.onBottom() } // ☑️
        }
        .modifier(🚨RegistrationErrorAlert())
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                if 📱.🚩ableDatePicker { 👆DoneButton.onToolbar() } // ☑️
            }
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                💟OpenHealthAppButton.onMainView()
                🛠MenuButton() // ⚙️
            }
        }
        .onChange(of: self.scenePhase) { _ in
            📱.📝resetInputValues()
        }
    }
}
