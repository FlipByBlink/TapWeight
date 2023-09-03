import SwiftUI

struct 🎚️BodyMassStepper: View {
    @EnvironmentObject var 📱: 📱AppModel
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    private var ⓘnputIsInvalid: Bool { 📱.📝massInputQuantity == nil }
    private var ⓐccessibilityLayout: Bool {
        📱.🚩amount50g || (self.dynamicTypeSize > .xLarge)
    }
    var body: some View {
        HStack {
            Button {
                📱.🎚️changeMassValue(.decrement)
            } label: {
                Image(systemName: "minus.circle.fill")
                    .symbolRenderingMode(.hierarchical)
                    .font(.title2)
                    .imageScale(.small)
            }
            .buttonStyle(.plain)
            Spacer()
            if self.ⓐccessibilityLayout {
                VStack(spacing: 0) {
                    self.ⓘnputValueLabel()
                    self.ⓤnitLabel()
                }
            } else {
                HStack(alignment: .firstTextBaseline, spacing: 2) {
                    self.ⓘnputValueLabel()
                    self.ⓤnitLabel()
                }
            }
            Spacer()
            Button {
                📱.🎚️changeMassValue(.increment)
            } label: {
                Image(systemName: "plus.circle.fill")
                    .symbolRenderingMode(.hierarchical)
                    .font(.title2)
                    .imageScale(.small)
            }
            .buttonStyle(.plain)
        }
        .monospacedDigit()
        .minimumScaleFactor(0.5)
        .lineLimit(1)
    }
    private func ⓘnputValueLabel() -> some View {
        Text(📱.ⓜassInputDescription)
            .font(.system(.title2, design: .rounded, weight: .heavy))
            .opacity(self.ⓘnputIsInvalid ? 0.5 : 1)
            .animation(.default.speed(2), value: self.ⓘnputIsInvalid)
    }
    private func ⓤnitLabel() -> some View {
        Text(📱.ⓜassUnitDescription ?? "kg")
            .font(.system(.title3, design: .rounded, weight: .heavy))
            .dynamicTypeSize(..<DynamicTypeSize.xLarge)
    }
}
