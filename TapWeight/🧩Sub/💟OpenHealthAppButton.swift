import SwiftUI

struct 💟OpenHealthAppButton: View {
    var body: some View {
        Link(destination: URL(string: "x-apple-health://")!) {
            Label {
                Text("Open \"Health\" app")
            } icon: {
                Image(systemName: "app")
                    .imageScale(.large)
                    .overlay {
                        Image(systemName: "heart")
                            .resizable()
                            .font(.body.weight(.semibold))
                            .scaleEffect(0.5)
                    }
            }
        }
    }
    static func onMainView() -> some View {
        Self()
            .font(.title2)
            .foregroundColor(.primary)
    }
    static func onResultView() -> some ToolbarContent {
        ToolbarItem {
            Self()
                .font(.title)
                .foregroundColor(.primary)
        }
    }
    static func onMenuView() -> some View {
        Section {
            HStack {
                Self()
                Spacer()
                Image(systemName: "arrow.up.forward.app")
                    .font(.body.weight(.light))
                    .imageScale(.small)
                    .foregroundColor(.accentColor)
            }
        }
    }
}
