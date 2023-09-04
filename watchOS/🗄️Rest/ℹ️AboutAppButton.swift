import SwiftUI

struct ℹ️AboutAppButton: View {
    @State private var showSheet: Bool = false
    var body: some View {
        Section {
            Button {
                self.showSheet = true
                💥Feedback.light()
            } label: {
                HStack {
                    Spacer()
                    Label("Open menu", systemImage: "questionmark.circle.fill")
                        .labelStyle(.iconOnly)
                        .symbolRenderingMode(.hierarchical)
                        .font(.title2)
                    Spacer()
                }
            }
            .buttonStyle(.plain)
            .listRowBackground(Color.clear)
        }
        .sheet(isPresented: self.$showSheet) {
            NavigationStack {
                ℹ️AboutAppMenu()
            }
        }
    }
}
