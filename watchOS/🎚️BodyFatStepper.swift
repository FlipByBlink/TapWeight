import SwiftUI

struct 🎚️BodyFatStepper: View {
    @EnvironmentObject var 📱: 📱AppModel
    private var ⓘnputIsInvalid: Bool { 📱.📝bodyFatInputQuantity == nil }
    var body: some View {
        HStack {
            Button {
                📱.🎚️changeBodyFatValue(.decrement)
            } label: {
                Image(systemName: "minus.circle.fill")
                    .symbolRenderingMode(.hierarchical)
                    .font(.title2)
                    .imageScale(.small)
            }
            .buttonStyle(.plain)
            Spacer()
            HStack(alignment: .firstTextBaseline, spacing: 2) {
                Text(📱.ⓑodyFatInputDescription)
                    .font(.system(.title2, design: .rounded, weight: .heavy))
                    .opacity(self.ⓘnputIsInvalid ? 0.5 : 1)
                    .animation(.default.speed(2), value: self.ⓘnputIsInvalid)
                Text("%")
                    .font(.system(.title3, design: .rounded, weight: .heavy))
            }
            Spacer()
            Button {
                📱.🎚️changeBodyFatValue(.increment)
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
}
