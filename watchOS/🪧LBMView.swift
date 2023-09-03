import SwiftUI

struct 🪧LBMView: View {
    @EnvironmentObject var 📱: 📱AppModel
    private var ⓘnputDescription: String? { 📱.ⓛbmInputDescription }
    var body: some View {
        VStack(alignment: .leading) {
            Text("Lean Body Mass")
                .font(.caption2.weight(.semibold))
            Text(ⓘnputDescription ?? "Error")
                .font(.subheadline.bold().monospacedDigit())
        }
        .lineLimit(1)
        .minimumScaleFactor(0.5)
        .foregroundStyle(.secondary)
        .animation(.default, value: self.ⓘnputDescription == nil)
    }
}
