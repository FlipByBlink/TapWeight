import SwiftUI
import HealthKit

struct 🪧LBMView: View {
    @EnvironmentObject var 📱: 📱AppModel
    private var ⓘnputDescription: String? { 📱.ⓛbmInputDescription }
    private var ⓐbleDatePicker: Bool { 📱.🚩ableDatePicker }
    var body: some View {
        if 📱.🚩ableLBM, let ⓘnputDescription {
            Section {
                HStack {
                    Text(ⓘnputDescription)
                        .font(self.ⓐbleDatePicker ? .body : .title)
                        .fontWeight(.heavy)
                        .frame(maxHeight: 42)
                        .monospacedDigit()
                    Spacer()
                    📉DifferenceView(.leanBodyMass)
                        .padding(.trailing, 12)
                }
                .padding(.vertical, self.ⓐbleDatePicker ? 0 : 4)
                .padding(.leading)
                .foregroundStyle(.secondary)
            } header: {
                Text("Lean Body Mass")
            }
        }
    }
}
