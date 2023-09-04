import SwiftUI

enum 🧩Layout {
    case regular, compact, sideBySide
}

extension EnvironmentValues {
    var ⓛayout: 🧩Layout {
        get { self[Self.🧩LayoutKey.self] }
        set { self[Self.🧩LayoutKey.self] = newValue }
    }
    private struct 🧩LayoutKey: EnvironmentKey {
        static let defaultValue: 🧩Layout = .regular
    }
}

struct 🧩LayoutHandle: ViewModifier {
    @EnvironmentObject var 📱: 📱AppModel
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    func body(content: Content) -> some View {
        content.environment(\.ⓛayout, self.activeLayout)
    }
    private var activeLayout: 🧩Layout {
        switch self.horizontalSizeClass {
            case .regular:
                if 📱.🚩ableDatePicker {
                    .sideBySide
                } else {
                    .regular
                }
            case .compact:
                if 📱.🚩ableDatePicker {
                    .compact
                } else {
                    .regular
                }
            default:
                    .regular
        }
    }
}
