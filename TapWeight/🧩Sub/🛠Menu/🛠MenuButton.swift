
import SwiftUI

struct 🛠MenuButton: View { // ⚙️
    @EnvironmentObject var 📱: 📱AppModel
    
    var body: some View {
        Button {
            📱.🚩ShowMenu = true
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        } label: {
            Image(systemName: "gear")
                .font(.largeTitle)
                .foregroundColor(.pink)
                .padding(24)
        }
        .accessibilityLabel("Open menu")
        .sheet(isPresented: $📱.🚩ShowMenu) {
            🛠AppMenu()
        }
    }
}
