
import SwiftUI

struct 🛠MenuButton: View { // ⚙️
    @State private var 🚩Menu: Bool = false
    
    var body: some View {
        Button {
            UISelectionFeedbackGenerator().selectionChanged()
            🚩Menu = true
        } label: {
            Image(systemName: "gear")
                .font(.largeTitle)
                .foregroundStyle(.secondary)
                .foregroundColor(.pink)
                .padding(24)
        }
        .accessibilityLabel("🌏Open menu")
        .sheet(isPresented: $🚩Menu) {
            🛠MenuList()
        }
    }
}
