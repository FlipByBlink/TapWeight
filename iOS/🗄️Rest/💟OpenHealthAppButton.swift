import SwiftUI

enum 💟OpenHealthAppButton {
    static var url: URL { .init(string: "x-apple-health://")! }
    static var title: LocalizedStringKey {
        #"Open "Health" app"#
    }
    static func image() -> some View {
        ZStack {
            Image(systemName: "app")
                .imageScale(.large)
                .fontWeight(.light)
            Image(systemName: "heart")
                .fontWeight(.medium)
                .imageScale(.small)
        }
    }
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
            .tint(.primary)
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
