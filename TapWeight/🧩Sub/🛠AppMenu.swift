import SwiftUI

struct 🛠MenuButton: View { // ⚙️
    @State private var 🚩showMenu: Bool = false
    var body: some View {
        Button {
            self.🚩showMenu = true
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        } label: {
            Image(systemName: "gearshape")
                .foregroundColor(.primary)
        }
        .accessibilityLabel("Open menu")
        .sheet(isPresented: self.$🚩showMenu) {
            🛠AppMenu()
        }
    }
}

struct 🛠AppMenu: View {
    @EnvironmentObject var 📱: 📱AppModel
    @Environment(\.dismiss) var dismiss
    var body: some View {
        if #available(iOS 16.0, *) {
            NavigationStack { self.ⓒontent() }
        } else {
            NavigationView { self.ⓒontent() }
        }
    }
    private func ⓒontent() -> some View {
        List {
            Section {
                if 📱.ⓜassUnit == .gramUnit(with: .kilo) {
                    Toggle(isOn: $📱.🚩amount50g) {
                        Label("100g → 50g", systemImage: "minus.forwardslash.plus")
                    }
                    .font(.subheadline)
                    .accessibilityLabel("50gram")
                }
                self.ⓑmiLink()
                Toggle(isOn: $📱.🚩ableBodyFat) {
                    Label("Body Fat Percentage", systemImage: "percent")
                }
                .onChange(of: 📱.🚩ableBodyFat) {
                    if $0 == true { 📱.ⓡequestAuth(.bodyFatPercentage) }
                }
                Toggle(isOn: $📱.🚩ableDatePicker) {
                    Label("Date picker", systemImage: "calendar.badge.clock")
                }
                .onChange(of: 📱.🚩ableDatePicker) { _ in
                    📱.📅datePickerValue = .now
                }
            } header: {
                Text("Option")
            }
            self.ⓞpenHealthAppButton()
            ℹ️AboutAppLink(name: "TapWeight", subtitle: "App for iPhone / Apple Watch")
            📣ADMenuLink()
        }
        .navigationTitle("Menu")
        .toolbar { self.ⓓismissButton() }
    }
    private func ⓑmiLink() -> some View {
        NavigationLink {
            List {
                Toggle(isOn: $📱.🚩ableBMI) {
                    Label("Body Mass Index", systemImage: "function")
                }
                .onChange(of: 📱.🚩ableBMI) {
                    if $0 == true { 📱.ⓡequestAuth(.bodyMassIndex) }
                }
                self.ⓐboutBMI()
            }
            .navigationBarTitleDisplayMode(.inline)
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
                    Text(ⓗeightSample.quantity.description)
                        .badge(ⓗeightSample.startDate.formatted())
                } else {
                    Text("Required height data access in \"Health\" app.")
                }
            } header: {
                Text("Height")
            }
        }
    }
    private func ⓞpenHealthAppButton() -> some View {
        Section {
            HStack {
                💟OpenHealthAppButton()
                Spacer()
                Image(systemName: "arrow.up.forward.app")
                    .font(.body.weight(.light))
                    .imageScale(.small)
                    .foregroundColor(.accentColor)
            }
        }
    }
    private func ⓓismissButton() -> some View {
        Button {
            self.dismiss()
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        } label: {
            Image(systemName: "chevron.down")
                .foregroundStyle(.secondary)
                .grayscale(1.0)
                .padding(8)
        }
        .accessibilityLabel("Dismiss")
    }
}
