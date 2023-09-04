import SwiftUI

struct 🛠BMIMenu: View {
    @EnvironmentObject var 📱: 📱AppModel
    var body: some View {
        List {
            Section {
                Toggle(isOn: $📱.🚩ableBMI) {
                    Label("Body Mass Index", systemImage: "function")
                }
            } header: {
                Text("Option")
            }
            self.ⓕomulaSection()
            self.ⓗeightSection()
            self.ⓑodyMassSection()
        }
        .navigationTitle("Body Mass Index")
    }
}

private extension 🛠BMIMenu {
    private func ⓕomulaSection() -> some View {
        Section {
            ZStack {
                Color.clear
                HStack {
                    Text(verbatim: "BMI = ")
                        .frame(maxWidth: 60)
                    VStack(spacing: 12) {
                        HStack(spacing: 2) {
                            Text("Body Mass")
                            Text(verbatim: "(kg)").font(.subheadline)
                        }
                        HStack(spacing: 2) {
                            Text("Height").layoutPriority(1)
                            Text(verbatim: "(m)").layoutPriority(1).font(.subheadline)
                            Text(verbatim: " × ").layoutPriority(1)
                            Text("Height").layoutPriority(1)
                            Text(verbatim: "(m)").layoutPriority(1).font(.subheadline)
                        }
                    }
                    .padding()
                    .overlay { Rectangle().frame(height: 1.33) }
                }
            }
            .lineLimit(1)
            .minimumScaleFactor(0.1)
        } header: {
            Text("Formula")
        }
    }
    private func ⓗeightSection() -> some View {
        Section {
            if let ⓗeightSample = 📱.📦latestSamples[.height], let ⓗeightUnit = 📱.ⓗeightUnit {
                HStack(alignment: .firstTextBaseline) {
                    Text(ⓗeightSample.quantity.doubleValue(for: ⓗeightUnit).formatted() + ⓗeightUnit.unitString)
                    if ⓗeightUnit != .meter() {
                        Text(verbatim: "(\(ⓗeightSample.quantity.doubleValue(for: .meter()).formatted())m)")
                            .foregroundStyle(.secondary)
                            .font(.caption)
                    }
                }
                .badge(Text(ⓗeightSample.startDate, style: .date))
            } else {
                Text("Required height data access in \"Health\" app.")
                💟OpenHealthAppButton.onMenuView()
            }
        } header: {
            Text("Height")
        }
    }
    private func ⓑodyMassSection() -> some View {
        Group {
            if 📱.ⓜassUnit != .gramUnit(with: .kilo) {
                if let ⓢample = 📱.📦latestSamples[.bodyMass] {
                    Section {
                        HStack(alignment: .firstTextBaseline) {
                            Text(ⓢample.quantity.description)
                            Text(verbatim: "(\(String(format: "%.2f", ⓢample.quantity.doubleValue(for: .gramUnit(with: .kilo))))kg)")
                                .foregroundStyle(.secondary)
                                .font(.caption)
                        }
                        .badge(Text(ⓢample.startDate, style: .date))
                    } header: {
                        Text("Body Mass")
                    }
                }
            }
        }
    }
}
