import SwiftUI

struct 🪧BMIView: View {
    @EnvironmentObject var 📱: 📱AppModel
    private var ⓘnputValue: Double? { 📱.ⓑmiInputValue }
    private var ⓓescription: String? { 📱.📦latestSamples[.height]?.quantity.description }
    var body: some View {
        if let ⓘnputValue, let ⓓescription {
            HStack {
                VStack(alignment: .leading, spacing: -4) {
                    HStack(alignment: .firstTextBaseline, spacing: 4) {
                        Text("Body Mass Index")
                            .font(.footnote.bold())
                        Text("(\(ⓓescription))")
                            .font(.caption2.weight(.semibold))
                            .frame(maxHeight: 32)
                    }
                    Text(ⓘnputValue.description)
                        .font(.title2)
                        .fontWeight(.heavy)
                }
                .monospacedDigit()
                Spacer()
                📉DifferenceView(.bodyMassIndex)
                    .padding(.trailing, 12)
            }
            .padding(.vertical, 4)
            .padding(.leading, 32)
            .foregroundStyle(.secondary)
        } else {
            GroupBox {
                Text("Height data is nothing on \"Health\" app. Register height data on \"Health\" app.")
            } label: {
                Text("Body Mass Index")
            }
            .foregroundStyle(.secondary)
        }
    }
}
