import SwiftUI

struct 🪧BMIView: View {
    @EnvironmentObject var 📱: 📱AppModel
    private var ⓘnputValue: Double? { 📱.ⓑmiInputValue }
    private var ⓗeightQuantityDescription: String? { 📱.ⓗeightQuantityDescription }
    private var ⓐbleDatePicker: Bool { 📱.🚩ableDatePicker }
    var body: some View {
        if 📱.🚩ableBMI {
            if let ⓘnputValue, let ⓗeightQuantityDescription {
                HStack {
                    VStack(alignment: .leading, spacing: -2) {
                        Group {
                            Text("Body Mass Index")
                            +
                            Text(" (\(ⓗeightQuantityDescription))")
                        }
                        .font(.footnote.bold())
                        .frame(maxHeight: 32)
                        Text(ⓘnputValue.description)
                            .font(self.ⓐbleDatePicker ? .body : .title)
                            .fontWeight(.heavy)
                            .frame(maxHeight: 42)
                    }
                    .monospacedDigit()
                    Spacer()
                    📉DifferenceView(.bodyMassIndex)
                        .padding(.trailing, 12)
                }
                .padding(.vertical, self.ⓐbleDatePicker ? 0 : 4)
                .padding(.leading, 32)
                .foregroundStyle(.secondary)
                .task { 📱.ⓡequestAuth([.bodyMassIndex]) } // For previous version user.
            } else {
                Text("__Body Mass Index:__ Height data is nothing on \"Health\" app. Register height data.")
                    .font(.footnote)
                    .foregroundStyle(.tertiary)
                    .padding(.leading, 32)
                    .frame(maxHeight: 80)
            }
        }
    }
}
