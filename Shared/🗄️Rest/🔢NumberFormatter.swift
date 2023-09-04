import Foundation

enum 🔢NumberFormatter {
    static func string(_ ⓥalue: Double, minimumDigits ⓜinimumFractionDigits: Int = 1) -> String {
        let ⓕormatter = NumberFormatter()
        ⓕormatter.minimumFractionDigits = ⓜinimumFractionDigits
        if let ⓡesult = ⓕormatter.string(for: ⓥalue) {
            return ⓡesult
        } else {
            assertionFailure()
            return ⓕormatter.string(for: 0.0) ?? "🐛"
        }
    }
}
