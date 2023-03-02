import SwiftUI
import HealthKit

struct 📉DifferenceView: View {
    @EnvironmentObject var 📱: 📱AppModel
    private var ⓒategory: 🏥Category
    private var ⓓescription: String? { 📱.ⓓifferenceDescriptions[self.ⓒategory] }
    private var ⓛastSampleDate: Date? { 📱.📦latestSamples[self.ⓒategory]?.startDate }
    var body: some View {
        ZStack {
            Color.clear
            if !📱.🚩ableDatePicker || 📱.ⓓatePickerIsAlmostNow {
                if let ⓓescription, let ⓛastSampleDate {
                    VStack(spacing: 0) {
                        Text(ⓓescription)
                            .font(.subheadline.bold())
                            .monospacedDigit()
                            .frame(width: 72, height: 24, alignment: .bottomTrailing)
                        Text(ⓛastSampleDate, style: .offset)
                            .font(.caption.bold())
                            .frame(width: 72, height: 24, alignment: .topTrailing)
                    }
                    .foregroundStyle(.tertiary)
                    .minimumScaleFactor(0.1)
                }
            }
        }
        .frame(width: 72, height: 48)
        .animation(.default.speed(2), value: 📱.ⓓatePickerIsAlmostNow)
    }
    init(_ ⓒategory: 🏥Category) {
        self.ⓒategory = ⓒategory
    }
}
