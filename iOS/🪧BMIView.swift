import SwiftUI

struct 🪧BMIView: View {
    @EnvironmentObject var 📱: 📱AppModel
    @Environment(\.ⓛayout) var ⓛayout
    private var ⓘnputDescription: String? { 📱.ⓑmiInputDescription }
    private var ⓗeightDescription: String? { 📱.ⓗeightDescription }
    var body: some View {
        if 📱.🚩ableBMI {
            if let ⓘnputDescription, let ⓗeightDescription {
                HStack {
                    VStack(alignment: .leading, spacing: -2) {
                        Text("Body Mass Index")
                            .font(.footnote.bold())
                            .frame(maxHeight: 32)
                        HStack(alignment: .lastTextBaseline, spacing: 4) {
                            Text(ⓘnputDescription)
                                .fontWeight(.heavy)
                                .font(self.ⓛayout == .compact ? .body : .title)
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
                .padding(.vertical, self.ⓛayout == .compact ? 0 : 4)
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
