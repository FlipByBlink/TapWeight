import SwiftUI

struct 🛠MenuButton: View { // ⚙️
    @State private var 🚩showMenu: Bool = false
    var body: some View {
        NavigationLink {
            🛠AppMenu()
        } label: {
            Label("Open menu", systemImage: "gearshape")
        }
        .tint(.primary)
    }
}

private struct 🛠AppMenu: View {
    @EnvironmentObject var 📱: 📱AppModel
    var body: some View {
        List {
            Section {
                🛠BMIMenuLink()
                Toggle(isOn: $📱.🚩ableBodyFat) {
                    Label("Body Fat Percentage", systemImage: "percent")
                }
                .onChange(of: 📱.🚩ableBodyFat) {
                    if $0 == true { 📱.ⓡequestAuth(.bodyFatPercentage) }
                }
                🛠LBMMenuLink()
                Toggle(isOn: $📱.🚩ableDatePicker) {
                    Label("Date picker", systemImage: "calendar.badge.clock")
                }
                .onChange(of: 📱.🚩ableDatePicker) { _ in
                    📱.📅datePickerValue = .now
                }
                if 📱.ⓜassUnit == .gramUnit(with: .kilo) {
                    Toggle(isOn: $📱.🚩amount50g) {
                        Label("0.1kg → 0.05kg", systemImage: "minus.forwardslash.plus")
                    }
                    .font(.subheadline)
                    .accessibilityLabel("50gram")
                }
            } header: {
                Text("Option")
            }
            💟OpenHealthAppButton.onMenuView()
            ℹ️AboutAppLink(name: "TapWeight", subtitle: "App for iPhone / Apple Watch")
            📣ADMenuLink()
        }
        .navigationTitle("Menu")
    }
    
}

private struct 🛠BMIMenuLink: View {
    @EnvironmentObject var 📱: 📱AppModel
    var body: some View {
        NavigationLink {
            List {
                Section {
                    Toggle(isOn: $📱.🚩ableBMI) {
                        Label("Body Mass Index", systemImage: "function")
                    }
                    .onChange(of: 📱.🚩ableBMI) {
                        if $0 == true { 📱.ⓡequestAuth(.bodyMassIndex) }
                    }
                } header: {
                    Text("Option")
                }
                self.ⓐboutBMI()
            }
            .navigationTitle("Body Mass Index")
        } label: {
            Label("Body Mass Index", systemImage: "function")
        }
    }
    private func ⓐboutBMI() -> some View {
        Group {
            Section {
                ZStack {
                    Color.clear
                    HStack {
                        Text("BMI = ")
                        VStack(spacing: 12) {
                            HStack(spacing: 2) {
                                Text("Weight")
                                Text("(kg)").font(.subheadline)
                            }
                            HStack(spacing: 2) {
                                Text("Height").layoutPriority(1)
                                Text("(m)").layoutPriority(1).font(.subheadline)
                                Text(" × ").layoutPriority(1)
                                Text("Height").layoutPriority(1)
                                Text("(m)").layoutPriority(1).font(.subheadline)
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
            Section {
                if let ⓗeightSample = 📱.📦latestSamples[.height] {
                    HStack {
                        Text(ⓗeightSample.quantity.description)
                        if 📱.ⓗeightUnit == .foot() {
                            Text("(" + ⓗeightSample.quantity.doubleValue(for: .meter()).description + "m)")
                                .foregroundStyle(.secondary)
                        }
                    }
                    .badge(ⓗeightSample.startDate.formatted())
                } else {
                    Text("Required height data access in \"Health\" app.")
                    💟OpenHealthAppButton.onMenuView()
                }
            } header: {
                Text("Height")
            }
        }
    }
}

private struct 🛠LBMMenuLink: View {
    @EnvironmentObject var 📱: 📱AppModel
    var body: some View {
        NavigationLink {
            List {
                Section {
                    Toggle(isOn: $📱.🚩ableLBM) {
                        Label("Lean Body Mass", systemImage: "person.badge.minus")
                    }
                    .onChange(of: 📱.🚩ableLBM) {
                        if $0 == true { 📱.ⓡequestAuth(.leanBodyMass) }
                    }
                } header: {
                    Text("Option")
                }
                Section {
                    ZStack {
                        Color.clear
                        Text("Body Mass")
                        +
                        Text(" - (")
                        +
                        Text("Body Mass")
                        +
                        Text(" × ")
                        +
                        Text("Body Fat Percentage")
                        +
                        Text(")")
                    }
                    .padding(12)
                } header: {
                    Text("Formula")
                }
            }
            .navigationTitle("Lean Body Mass")
        } label: {
            Label("Lean Body Mass", systemImage: "person.badge.minus")
        }
    }
}
