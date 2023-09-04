import SwiftUI
import HealthKit

struct 🪧LBMView: View {
    @EnvironmentObject var 📱: 📱AppModel
    @Environment(\.ⓛayout) var ⓛayout
    private var ⓘnputDescription: String? { 📱.ⓛbmInputDescription }
    var body: some View {
        if 📱.🚩ableLBM {
            if let ⓘnputDescription {
                HStack {
                    VStack(alignment: .leading, spacing: -2) {
                        Text("Lean Body Mass")
                            .font(.footnote.bold())
                            .frame(maxHeight: 32)
                        Text(ⓘnputDescription)
                            .font(self.ⓛayout == .compact ? .body : .title)
                            .fontWeight(.heavy)
                            .frame(maxHeight: 42)
                    }
                    .monospacedDigit()
                    Spacer()
                    📉DifferenceView(.leanBodyMass)
                        .padding(.trailing, 12)
                }
                .padding(.vertical, self.ⓛayout == .compact ? 0 : 4)
                .padding(.leading, 32)
                .foregroundStyle(.secondary)
            } else {
                Text("__Lean Body Mass:__ Error")
            }
        }
    }
}
