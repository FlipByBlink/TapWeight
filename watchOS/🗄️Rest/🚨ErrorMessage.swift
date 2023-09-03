import SwiftUI

struct 🚨ErrorMessage: View {
    @EnvironmentObject var 📱: 📱AppModel
    private var ⓘnvalidSampleCategories: [🏥Category] {
        var ⓥalue: [🏥Category] = []
        if 📱.📦latestSamples[.bodyMass] == nil {
            ⓥalue += [.bodyMass]
        }
        if 📱.🚩ableBMI && (📱.📦latestSamples[.height] == nil) {
            ⓥalue += [.height]
        }
        if 📱.🚩ableBodyFat && (📱.📦latestSamples[.bodyFatPercentage] == nil) {
            ⓥalue += [.bodyFatPercentage]
        }
        return ⓥalue
    }
    private var ⓐppIsInvalid: Bool { !self.ⓘnvalidSampleCategories.isEmpty }
    var body: some View {
        if self.ⓐppIsInvalid {
            VStack(spacing: 4) {
                Text("⚠️ Error")
                    .font(.headline)
                Text("Please launch iPhone app to sync. If registered data is nothing, register your data to \"Health\". Or check authentication on Apple Watch.")
                    .font(.caption2)
                VStack(alignment: .leading) {
                    ForEach(self.ⓘnvalidSampleCategories, id: \.identifier) {
                        Text("・" + $0.localizedString)
                    }
                }
                .font(.caption2.weight(.semibold))
            }
            .foregroundStyle(.secondary)
            .padding(.vertical, 8)
        }
    }
}
