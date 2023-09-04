import SwiftUI

struct 🪧BMIView: View {
    @EnvironmentObject var 📱: 📱AppModel
    private var ⓘnputValue: Double? { 📱.ⓑmiInputValue }
    private var ⓗeightDescription: String? { 📱.ⓗeightDescription }
    var body: some View {
        VStack(alignment: .leading) {
            Text("Body Mass Index")
                .font(.caption2.weight(.semibold))
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            if let ⓘnputValue, let ⓗeightDescription {
                HStack {
                    Text(ⓘnputValue.description)
                        .font(.subheadline.bold())
                        .monospacedDigit()
                    Spacer()
                    Text(verbatim: "(\(ⓗeightDescription))")
                        .font(.caption2.bold())
                        .foregroundStyle(.tertiary)
                }
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            } else {
                Text("Height data is nothing on \"Health\" app. Register height data.")
                    .font(.footnote)
                    .foregroundStyle(.tertiary)
            }
        }
        .foregroundStyle(.secondary)
        .animation(.default, value: self.ⓘnputValue == nil)
    }
}
