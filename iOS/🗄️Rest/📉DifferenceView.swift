import SwiftUI
import HealthKit

struct 📉DifferenceView: View {
    @EnvironmentObject var 📱: 📱AppModel
    private var ⓒategory: 🏥Category
    private var ⓓifference: 📉Difference? { 📱.ⓓifference[self.ⓒategory] }
    private var ⓕrameHeight: Double { 📱.🚩ableDatePicker ? 36 : 42 }
    var body: some View {
        ZStack {
            Color.clear
            if !📱.🚩ableDatePicker || 📱.ⓓatePickerIsAlmostNow {
                if let ⓓifference {
                    VStack(spacing: 0) {
                        Text(ⓓifference.valueDescription)
                            .font(.subheadline.bold())
                            .monospacedDigit()
                            .frame(width: 72, height: self.ⓕrameHeight / 2, alignment: .bottomTrailing)
                        Text(ⓓifference.lastSampleDate, style: .offset)
                            .font(.caption.bold())
                            .frame(width: 72, height: self.ⓕrameHeight / 2, alignment: .topTrailing)
                    }
                    .foregroundStyle(.tertiary)
                    .minimumScaleFactor(0.1)
                }
            }
        }
        .frame(width: 72, height: self.ⓕrameHeight)
        .animation(.default.speed(2), value: 📱.ⓓatePickerIsAlmostNow)
    }
    init(_ ⓒategory: 🏥Category) {
        self.ⓒategory = ⓒategory
    }
}
