import SwiftUI

struct 👆BodyMassStepper: View {
    @EnvironmentObject var 📱: 📱AppModel
    private var 🔠font: Font { 📱.🚩ableDatePicker ? .largeTitle : .system(size: 50) }
    private var 🪧description: String {
        if let ⓥalue = 📱.📝massInputValue {
            return 📱.🚩amount50g ? String(format: "%.2f", ⓥalue) : ⓥalue.description
        } else {
            return 📱.🚩amount50g ? "00.00" : "00.0"
        }
    }
    private var ⓟreviousSampleIsNothing: Bool { 📱.📦latestSamples[.bodyMass] == nil }
    var body: some View {
        Stepper {
            HStack {
                HStack(alignment: .firstTextBaseline) {
                    Text(self.🪧description)
                        .font(self.🔠font)
                        .fontWeight(.black)
                        .monospacedDigit()
                        .animation(.default, value: self.ⓟreviousSampleIsNothing)
                    Text(📱.📦units[.bodyMass]?.description ?? "nil")
                        .font(.title2.weight(.black))
                        .frame(maxHeight: 36)
                }
                Spacer(minLength: 4)
                📉DifferenceView(.bodyMass)
            }
        } onIncrement: {
            UISelectionFeedbackGenerator().selectionChanged()
            📱.incrementMassStepper()
        } onDecrement: {
            UISelectionFeedbackGenerator().selectionChanged()
            📱.decrementMassStepper()
        }
        .padding(8)
        .padding(.vertical, 4)
    }
}

struct 👆BodyFatStepper: View {
    @EnvironmentObject var 📱: 📱AppModel
    private var 🔠font: Font { 📱.🚩ableDatePicker ? .largeTitle : .system(size: 50) }
    private var 🪧description: String {
        if let ⓥalue = 📱.📝bodyFatInputValue {
            return (round(ⓥalue * 1000) / 10).description
        } else {
            return "00.0"
        }
    }
    private var ⓟreviousSampleIsNothing: Bool { 📱.📦latestSamples[.bodyFatPercentage] == nil }
    var body: some View {
        Section {
            Stepper {
                HStack {
                    HStack(alignment: .firstTextBaseline, spacing: 6) {
                        Text(self.🪧description)
                            .font(self.🔠font)
                            .fontWeight(.black)
                            .monospacedDigit()
                            .animation(.default, value: self.ⓟreviousSampleIsNothing)
                        Text("%")
                            .font(.title2.weight(.black))
                            .frame(maxHeight: 54)
                    }
                    Spacer(minLength: 0)
                    📉DifferenceView(.bodyFatPercentage)
                }
            } onIncrement: {
                UISelectionFeedbackGenerator().selectionChanged()
                📱.incrementBodyFatStepper()
            } onDecrement: {
                UISelectionFeedbackGenerator().selectionChanged()
                📱.decrementBodyFatStepper()
            }
            .padding(8)
            .padding(.vertical, 4)
        } header: {
            Text("Body Fat Percentage")
        }
    }
}
