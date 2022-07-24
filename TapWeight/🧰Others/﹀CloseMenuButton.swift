
import SwiftUI

struct ﹀CloseMenuButton: ToolbarContent {
    @Binding var 🚩ShowMenu: Bool
    
    var body: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button {
                🚩ShowMenu = false
                UISelectionFeedbackGenerator().selectionChanged()
            } label: {
                Image(systemName: "chevron.down")
                    .foregroundStyle(.secondary)
                    .grayscale(1.0)
                    .padding(8)
            }
            .accessibilityLabel("Dismiss")
        }
    }
    
    init(_ 🚩: Binding<Bool>) {
        _🚩ShowMenu = 🚩
    }
}
