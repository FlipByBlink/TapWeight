import SwiftUI

enum 💟OpenHealthAppButton {
    static func onMainView() -> some View {
        Link(destination: Self.url) {
            self.image()
        }
        .accessibilityLabel(Self.title)
        .font(.title2)
        .tint(.primary)
    }
    static func onResultView() -> some ToolbarContent {
        ToolbarItem {
            Link(destination: Self.url) {
                self.image()
            }
            .accessibilityLabel(Self.title)
            .font(.title)
            .foregroundStyle(.white)
        }
    }
    static func onMenuView() -> some View {
        Section {
            HStack {
                Link(destination: Self.url) {
                    Label {
                        Text(self.title)
                    } icon: {
                        self.image()
                    }
                }
                .accessibilityLabel(Self.title)
                Spacer()
                Image(systemName: "arrow.up.forward.app")
                    .font(.body.weight(.light))
                    .imageScale(.small)
                    .foregroundColor(.accentColor)
            }
        }
    }
}

private extension 💟OpenHealthAppButton {
    private static var url: URL { .init(string: "x-apple-health://")! }
    private static var title: LocalizedStringKey {
        #"Open "Health" app"#
    }
    private static func image() -> some View {
        ZStack {
            Image(systemName: "app")
                .imageScale(.large)
                .fontWeight(.light)
            Image(systemName: "heart")
                .fontWeight(.medium)
                .imageScale(.small)
        }
    }
}
