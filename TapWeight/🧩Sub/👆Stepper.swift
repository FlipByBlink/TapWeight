import SwiftUI

struct 👆BodyMassStepper: View {
    @EnvironmentObject var 📱: 📱AppModel
    private var 🔠font: Font { 📱.🚩ableDatePicker ? .largeTitle : .system(size: 50) }
    private var 🪧description: String {
        if let ⓥalue = 📱.ⓜassInputValue {
            return 📱.🚩amount50g ? String(format: "%.2f", ⓥalue) : ⓥalue.description
        } else {
            return 📱.🚩amount50g ? "00.00" : "00.0"
        }
    }
    private var ⓘnputQuantityIsNothing: Bool { 📱.📝massInputQuantity == nil }
    var body: some View {
        Stepper {
            HStack {
                HStack(alignment: .firstTextBaseline) {
                    Text(self.🪧description)
                        .font(self.🔠font)
                        .fontWeight(.black)
                        .monospacedDigit()
                        .opacity(self.ⓘnputQuantityIsNothing ? 0.2 : 1)
                        .animation(.default, value: self.ⓘnputQuantityIsNothing)
                    Text(📱.📦units[.bodyMass]?.description ?? "nil")
                        .font(.title2.weight(.black))
                        .frame(maxHeight: 36)
                }
                Spacer(minLength: 4)
                📉DifferenceView(.bodyMass)
            }
        } onIncrement: {
            UISelectionFeedbackGenerator().selectionChanged()
            📱.stepMassValue(.increment)
        } onDecrement: {
            UISelectionFeedbackGenerator().selectionChanged()
            📱.stepMassValue(.decrement)
        }
        .padding(8)
        .padding(.vertical, 4)
    }
}

struct 👆BodyFatStepper: View {
    @EnvironmentObject var 📱: 📱AppModel
    private var 🔠font: Font { 📱.🚩ableDatePicker ? .largeTitle : .system(size: 50) }
    private var 🪧description: String {
        if let ⓥalue = 📱.ⓑodyFatInputValue {
            return (round(ⓥalue * 1000) / 10).description
        } else {
            return "00.0"
        }
    }
    private var ⓘnputQuantityIsNothing: Bool { 📱.📝bodyFatInputQuantity == nil }
    var body: some View {
        Section {
            Stepper {
                HStack {
                    HStack(alignment: .firstTextBaseline, spacing: 6) {
                        Text(self.🪧description)
                            .font(self.🔠font)
                            .fontWeight(.black)
                            .monospacedDigit()
                            .opacity(self.ⓘnputQuantityIsNothing ? 0.2 : 1)
                            .animation(.default, value: self.ⓘnputQuantityIsNothing)
                        Text("%")
                            .font(.title2.weight(.black))
                            .frame(maxHeight: 54)
                    }
                    Spacer(minLength: 0)
                    📉DifferenceView(.bodyFatPercentage)
                }
            } onIncrement: {
                UISelectionFeedbackGenerator().selectionChanged()
                📱.stepBodyFatValue(.increment)
            } onDecrement: {
                UISelectionFeedbackGenerator().selectionChanged()
                📱.stepBodyFatValue(.decrement)
            }
            .padding(8)
            .padding(.vertical, 4)
        } header: {
            Text("Body Fat Percentage")
        }
    }
}
