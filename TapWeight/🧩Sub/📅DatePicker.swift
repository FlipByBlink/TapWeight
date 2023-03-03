import SwiftUI

struct 📅DatePicker: View {
    @EnvironmentObject var 📱: 📱AppModel
    @Environment(\.scenePhase) var scenePhase
    var body: some View {
        if 📱.🚩ableDatePicker {
            Section {
                DatePicker(selection: $📱.📅datePickerValue, in: ...Date.now) {
                    EmptyView()
                }
                .datePickerStyle(.graphical)
                .onChange(of: self.scenePhase) {
                    if $0 == .background {
                        📱.📅datePickerValue = .now
                    }
                }
            } header: {
                Text("Date")
            }
        }
    }
}
