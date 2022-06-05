
import SwiftUI

struct 🛠MenuButton: View { // ⚙️
    @EnvironmentObject var 📱:📱Model
    
    var body: some View {
        Button {
            UISelectionFeedbackGenerator().selectionChanged()
            📱.🚩Menu = true
        } label: {
            Image(systemName: "gear")
                .font(.largeTitle)
                .foregroundColor(.pink)
                .padding(24)
        }
        .accessibilityLabel("🌏Open menu")
        .sheet(isPresented: $📱.🚩Menu) {
            🛠MenuList()
                .onDisappear {
                    📱.🚩Menu = false
                }
        }
    }
}
