import SwiftUI

struct 👆BodyMassStepper: View {
    @EnvironmentObject var 📱: 📱AppModel
    private var 🔠font: Font { 📱.🚩ableDatePicker ? .largeTitle : .system(size: 50) }
    private var 🪧description: String {
        📱.🚩amount50g ? String(format: "%.2f", 📱.📝massValue) : 📱.📝massValue.description
    }
    var body: some View {
        Stepper {
            HStack {
                HStack(alignment: .firstTextBaseline) {
                    Text(self.🪧description)
                        .font(self.🔠font)
                        .fontWeight(.black)
                        .monospacedDigit()
                    Text(📱.📏massUnit.rawValue)
                        .font(.title2.weight(.black))
                        .frame(maxHeight: 36)
                }
                Spacer(minLength: 4)
                📉DifferenceView(.bodyMass)
            }
        } onIncrement: {
            UISelectionFeedbackGenerator().selectionChanged()
            if 📱.🚩amount50g {
                📱.📝massValue += 0.05
                📱.📝massValue = round(📱.📝massValue * 100) / 100
            } else {
                📱.📝massValue += 0.1
                📱.📝massValue = round(📱.📝massValue * 10) / 10
            }
        } onDecrement: {
            UISelectionFeedbackGenerator().selectionChanged()
            if 📱.🚩amount50g {
                📱.📝massValue -= 0.05
                📱.📝massValue = round(📱.📝massValue * 100) / 100
            } else {
                📱.📝massValue -= 0.1
                📱.📝massValue = round(📱.📝massValue * 10) / 10
            }
        }
        .padding(8)
        .padding(.vertical, 4)
    }
}

struct 👆BodyFatStepper: View {
    @EnvironmentObject var 📱: 📱AppModel
    private var 🔠font: Font { 📱.🚩ableDatePicker ? .largeTitle : .system(size: 50) }
    var body: some View {
        Section {
            Stepper {
                HStack {
                    HStack(alignment: .firstTextBaseline, spacing: 6) {
                        Text((round(📱.📝bodyFatValue * 1000) / 10).description)
                            .font(self.🔠font)
                            .fontWeight(.black)
                            .monospacedDigit()
                        Text("%")
                            .font(.title2.weight(.black))
                            .frame(maxHeight: 54)
                    }
                    Spacer(minLength: 0)
                    📉DifferenceView(.bodyFatPercentage)
                }
            } onIncrement: {
                UISelectionFeedbackGenerator().selectionChanged()
                📱.📝bodyFatValue += 0.001
                📱.📝bodyFatValue = round(📱.📝bodyFatValue * 1000) / 1000
            } onDecrement: {
                UISelectionFeedbackGenerator().selectionChanged()
                📱.📝bodyFatValue -= 0.001
                📱.📝bodyFatValue = round(📱.📝bodyFatValue * 1000) / 1000
            }
            .padding(8)
            .padding(.vertical, 4)
        } header: {
            Text("Body Fat Percentage")
        }
    }
}
