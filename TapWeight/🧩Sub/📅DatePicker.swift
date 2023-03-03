import SwiftUI

struct 📅DatePicker: View {
    @EnvironmentObject var 📱: 📱AppModel
    @Environment(\.scenePhase) var scenePhase
    var body: some View {
        if 📱.🚩ableDatePicker {
            Section {
                VStack(alignment: .trailing, spacing: 0) {
                    DatePicker(selection: $📱.📅datePickerValue, in: ...Date.now, displayedComponents: .date) {
                        Text("Date")
                    }
                    .datePickerStyle(.graphical)
                    DatePicker(selection: $📱.📅datePickerValue, in: ...Date.now, displayedComponents: .hourAndMinute) {
                        Text("HourAndMinute")
                    }
                }
                .labelsHidden()
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
