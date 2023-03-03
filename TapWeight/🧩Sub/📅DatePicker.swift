import SwiftUI

struct 📅DatePicker: View {
    @EnvironmentObject var 📱: 📱AppModel
    var body: some View {
        if 📱.🚩ableDatePicker {
            Section {
                DatePicker(selection: $📱.📅datePickerValue, in: ...Date.now) {
                    EmptyView()
                }
                .datePickerStyle(.graphical)
            } header: {
                Text("Date")
            }
        }
    }
}
