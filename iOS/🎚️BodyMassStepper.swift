import SwiftUI

struct 🎚️BodyMassStepper: View {
    @EnvironmentObject var 📱: 📱AppModel
    private var ⓐbleDatePicker: Bool { 📱.🚩ableDatePicker }
    private var ⓘnputIsInvalid: Bool { 📱.📝massInputQuantity == nil }
    var body: some View {
        Stepper {
            HStack {
                HStack(alignment: .firstTextBaseline) {
                    Text(📱.ⓜassInputDescription)
                        .font(self.ⓐbleDatePicker ? .title : .system(size: 46))
                        .fontWeight(.black)
                        .monospacedDigit()
                        .opacity(self.ⓘnputIsInvalid ? 0.3 : 1)
                        .animation(.default.speed(2), value: self.ⓘnputIsInvalid)
                    Text(📱.ⓜassUnitDescription ?? "kg")
                        .font(.title.weight(.black))
                        .frame(maxHeight: 36)
                }
                Spacer(minLength: 4)
                📉DifferenceView(.bodyMass)
            }
            .accessibilityLabel("")
        } onIncrement: {
            📱.🎚️changeMassValue(.increment)
        } onDecrement: {
            📱.🎚️changeMassValue(.decrement)
        }
        .accessibilityLabel("Body Mass")
        .lineLimit(1)
        .padding(.horizontal, 8)
        .padding(.vertical, self.ⓐbleDatePicker ? 2 : 8)
    }
}
