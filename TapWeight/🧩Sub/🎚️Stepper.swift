import SwiftUI

struct 🎚️BodyMassStepper: View {
    @EnvironmentObject var 📱: 📱AppModel
    private var ⓐbleDatePicker: Bool { 📱.🚩ableDatePicker }
    private var ⓘnputQuantityIsNothing: Bool { 📱.📝massInputQuantity == nil }
    var body: some View {
        Stepper {
            HStack {
                HStack(alignment: .firstTextBaseline) {
                    Text(📱.ⓜassInputDescription)
                        .font(self.ⓐbleDatePicker ? .title : .system(size: 50))
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
        .padding(.horizontal, 8)
        .padding(.vertical, self.ⓐbleDatePicker ? 2 : 12)
    }
}

struct 🎚️BodyFatStepper: View {
    @EnvironmentObject var 📱: 📱AppModel
    private var ⓐbleDatePicker: Bool { 📱.🚩ableDatePicker }
    private var ⓘnputQuantityIsNothing: Bool { 📱.📝bodyFatInputQuantity == nil }
    var body: some View {
        Section {
            Stepper {
                HStack {
                    HStack(alignment: .firstTextBaseline, spacing: 6) {
                        Text(📱.ⓑodyFatInputDescription)
                            .font(self.ⓐbleDatePicker ? .title : .system(size: 50))
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
            .padding(.horizontal, 8)
            .padding(.vertical, self.ⓐbleDatePicker ? 2 : 12)
        } header: {
            Text("Body Fat Percentage")
        }
    }
}
