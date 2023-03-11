import SwiftUI

struct 🎚️BodyMassStepper: View {
    @EnvironmentObject var 📱: 📱AppModel
    private var ⓐbleDatePicker: Bool { 📱.🚩ableDatePicker }
    private var ⓘnputIsValid: Bool { 📱.ⓜassInputIsValid }
    var body: some View {
        Stepper {
            HStack {
                HStack(alignment: .firstTextBaseline) {
                    Text(📱.ⓜassInputDescription)
                        .font(self.ⓐbleDatePicker ? .title : .system(size: 46))
                        .fontWeight(.black)
                        .monospacedDigit()
                    Text(📱.ⓜassUnit?.description ?? "kg")
                        .font(.title2.weight(.black))
                        .frame(maxHeight: 36)
                }
                .opacity(self.ⓘnputIsValid ? 1 : 0.1)
                .animation(.default, value: self.ⓘnputIsValid)
                Spacer(minLength: 4)
                📉DifferenceView(.bodyMass)
            }
        } onIncrement: {
            📱.🎚️changeMassValue(.increment)
        } onDecrement: {
            📱.🎚️changeMassValue(.decrement)
        }
        .lineLimit(1)
        .padding(.horizontal, 8)
        .padding(.vertical, self.ⓐbleDatePicker ? 2 : 8)
    }
}

struct 🎚️BodyFatStepper: View {
    @EnvironmentObject var 📱: 📱AppModel
    private var ⓐbleDatePicker: Bool { 📱.🚩ableDatePicker }
    private var ⓘnputIsValid: Bool { 📱.ⓑodyFatInputIsValid }
    var body: some View {
        if 📱.🚩ableBodyFat {
            Section {
                Stepper {
                    HStack {
                        HStack(alignment: .firstTextBaseline, spacing: 6) {
                            Text(📱.ⓑodyFatInputDescription)
                                .font(self.ⓐbleDatePicker ? .title : .system(size: 46))
                                .fontWeight(.black)
                                .monospacedDigit()
                            Text("%")
                                .font(.title2.weight(.black))
                                .frame(maxHeight: 54)
                        }
                        .opacity(self.ⓘnputIsValid ? 1 : 0.1)
                        .animation(.default, value: self.ⓘnputIsValid)
                        Spacer(minLength: 0)
                        📉DifferenceView(.bodyFatPercentage)
                    }
                } onIncrement: {
                    📱.🎚️changeBodyFatValue(.increment)
                } onDecrement: {
                    📱.🎚️changeBodyFatValue(.decrement)
                }
                .lineLimit(1)
                .padding(.horizontal, 8)
                .padding(.vertical, self.ⓐbleDatePicker ? 2 : 8)
            } header: {
                Text("Body Fat Percentage")
            }
        }
    }
}
