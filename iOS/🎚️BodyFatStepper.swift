import SwiftUI

struct 🎚️BodyFatStepper: View {
    @EnvironmentObject var 📱: 📱AppModel
    @Environment(\.ⓛayout) var ⓛayout
    private var ⓘnputIsInvalid: Bool { 📱.📝bodyFatInputQuantity == nil }
    var body: some View {
        if 📱.🚩ableBodyFat {
            Section {
                Stepper {
                    HStack {
                        HStack(alignment: .firstTextBaseline, spacing: 6) {
                            Text(📱.ⓑodyFatInputDescription)
                                .font(self.ⓛayout == .compact ? .title : .system(size: 46))
                                .fontWeight(.black)
                                .monospacedDigit()
                                .opacity(self.ⓘnputIsInvalid ? 0.3 : 1)
                                .animation(.default.speed(2), value: self.ⓘnputIsInvalid)
                            Text(verbatim: "%")
                                .font(.title.weight(.black))
                                .frame(maxHeight: 36)
                        }
                        Spacer(minLength: 0)
                        📉DifferenceView(.bodyFatPercentage)
                    }
                } onIncrement: {
                    📱.🎚️changeBodyFatValue(.increment)
                } onDecrement: {
                    📱.🎚️changeBodyFatValue(.decrement)
                }
                .accessibilityLabel("Body Fat Percentage")
                .lineLimit(1)
                .padding(.horizontal, 8)
                .padding(.vertical, self.ⓛayout == .compact ? 2 : 8)
            } header: {
                Text("Body Fat Percentage")
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
            }
        }
    }
}
