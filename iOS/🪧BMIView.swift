import SwiftUI

struct 🪧BMIView: View {
    @EnvironmentObject var 📱: 📱AppModel
    private var ⓘnputValue: Double? { 📱.ⓑmiInputValue }
    private var ⓗeightDescription: String? { 📱.ⓗeightDescription }
    private var ⓐbleDatePicker: Bool { 📱.🚩ableDatePicker }
    var body: some View {
        if 📱.🚩ableBMI {
            if let ⓘnputValue, let ⓗeightDescription {
                HStack {
                    VStack(alignment: .leading, spacing: -2) {
                        Text("Body Mass Index")
                            .font(.footnote.bold())
                            .frame(maxHeight: 32)
                        HStack(alignment: .lastTextBaseline, spacing: 4) {
                            Text(ⓘnputValue.description)
                                .fontWeight(.heavy)
                                .font(self.ⓐbleDatePicker ? .body : .title)
                            Text(verbatim: " (\(ⓗeightDescription))")
                                .font(.footnote.weight(.heavy))
                                .foregroundStyle(.tertiary)
                        }
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
            } else {
                Text("__Body Mass Index:__ Height data is nothing on \"Health\" app. Register height data. Or check authentication.")
                    .font(.footnote)
                    .foregroundStyle(.tertiary)
                    .padding(.leading, 32)
                    .frame(maxHeight: 80)
            }
        }
    }
}
