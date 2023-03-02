import SwiftUI

struct 🎚️BodyMassStepper: View {
    @EnvironmentObject var 📱: 📱AppModel
    private var 🔠font: Font { 📱.🚩ableDatePicker ? .largeTitle : .system(size: 50) }
    private var ⓘnputQuantityIsNothing: Bool { 📱.📝massInputQuantity == nil }
    var body: some View {
        Stepper {
            HStack {
                HStack(alignment: .firstTextBaseline) {
                    Text(📱.ⓜassInputDescription)
                        .font(self.🔠font)
                        .fontWeight(.black)
                        .monospacedDigit()
                    Text(📱.ⓜassUnit?.description ?? "kg")
                        .font(.title2.weight(.black))
                        .frame(maxHeight: 36)
                }
                .opacity(self.ⓘnputQuantityIsNothing ? 0.2 : 1)
                .animation(.default, value: self.ⓘnputQuantityIsNothing)
                Spacer(minLength: 4)
                📉DifferenceView(.bodyMass)
            }
        } onIncrement: {
            UISelectionFeedbackGenerator().selectionChanged()
            📱.🎚️changeMassValue(.increment)
        } onDecrement: {
            UISelectionFeedbackGenerator().selectionChanged()
            📱.🎚️changeMassValue(.decrement)
        }
        .lineLimit(1)
        .padding(8)
        .padding(.vertical, 4)
    }
}

struct 🎚️BodyFatStepper: View {
    @EnvironmentObject var 📱: 📱AppModel
    private var 🔠font: Font { 📱.🚩ableDatePicker ? .largeTitle : .system(size: 50) }
    private var ⓘnputQuantityIsNothing: Bool { 📱.📝bodyFatInputQuantity == nil }
    var body: some View {
        Section {
            Stepper {
                HStack {
                    HStack(alignment: .firstTextBaseline, spacing: 6) {
                        Text(📱.ⓑodyFatInputDescription)
                            .font(self.🔠font)
                            .fontWeight(.black)
                            .monospacedDigit()
                        Text("%")
                            .font(.title2.weight(.black))
                            .frame(maxHeight: 54)
                    }
                    .opacity(self.ⓘnputQuantityIsNothing ? 0.2 : 1)
                    .animation(.default, value: self.ⓘnputQuantityIsNothing)
                    Spacer(minLength: 0)
                    📉DifferenceView(.bodyFatPercentage)
                }
            } onIncrement: {
                UISelectionFeedbackGenerator().selectionChanged()
                📱.🎚️changeBodyFatValue(.increment)
            } onDecrement: {
                UISelectionFeedbackGenerator().selectionChanged()
                📱.🎚️changeBodyFatValue(.decrement)
            }
            .lineLimit(1)
            .padding(8)
            .padding(.vertical, 4)
        } header: {
            Text("Body Fat Percentage")
        }
    }
}
