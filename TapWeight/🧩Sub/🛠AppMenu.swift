import SwiftUI

struct 🛠MenuButton: View { // ⚙️
    @State private var 🚩showMenu: Bool = false
    var body: some View {
        NavigationLink {
            🛠AppMenu()
        } label: {
            Label("Open menu", systemImage: "gearshape")
                .font(.body.weight(.medium))
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
                    if $0 == false { 📱.🚩ableLBM = false }
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
                    .accessibilityLabel("50gram")
                }
                🛠ReminderMenuLink()
            } header: {
                Text("Option")
            }
            .onChange(of: 📱.ⓒontext) { $0.sendToWatchApp() }
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
                } header: {
                    Text("Option")
                }
                self.ⓕomulaSection()
                self.ⓗeightSection()
                self.ⓦeightSection()
            }
            .navigationTitle("Body Mass Index")
        } label: {
            Label("Body Mass Index", systemImage: "function")
        }
    }
    private func ⓕomulaSection() -> some View {
            Section {
                ZStack {
                    Color.clear
                    HStack {
                        Text("BMI = ")
                            .frame(maxWidth: 60)
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
        }
    private func ⓗeightSection() -> some View {
        Section {
            if let ⓗeightSample = 📱.📦latestSamples[.height] {
                HStack(alignment: .firstTextBaseline) {
                    Text(ⓗeightSample.quantity.description)
                    if 📱.ⓗeightUnit != .meter() {
                        Text("(" + ⓗeightSample.quantity.doubleValue(for: .meter()).formatted() + "m)")
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
    private func ⓦeightSection() -> some View {
        Group {
            if 📱.ⓜassUnit != .gramUnit(with: .kilo) {
                if let ⓜassSample = 📱.📦latestSamples[.bodyMass] {
                    Section {
                        HStack(alignment: .firstTextBaseline) {
                            Text(ⓜassSample.quantity.description)
                            Text("(" + ⓜassSample.quantity.doubleValue(for: .gramUnit(with: .kilo)).formatted() + "kg)")
                                .foregroundStyle(.secondary)
                                .font(.caption)
                        }
                        .badge(Text(ⓜassSample.startDate, style: .date))
                    } header: {
                        Text("Weight")
                    }
                }
            }
        }
    }
}

private struct 🛠LBMMenuLink: View {
    @EnvironmentObject var 📱: 📱AppModel
    private var ⓕomulaDescription: String {
        String(localized: "Body Mass")
        +
        " - ("
        +
        String(localized: "Body Mass")
        +
        " × "
        +
        String(localized: "Body Fat Percentage")
        +
        ")"
    }
    var body: some View {
        NavigationLink {
            List {
                Section {
                    Toggle(isOn: $📱.🚩ableLBM) {
                        Label("Lean Body Mass", systemImage: "person.badge.minus")
                    }
                    .disabled(!📱.🚩ableBodyFat)
                    .onChange(of: 📱.🚩ableLBM) {
                        if $0 == true { 📱.🚩ableBodyFat = true }
                    }
                } header: {
                    Text("Option")
                } footer: {
                    if !📱.🚩ableBodyFat {
                        Text("⚠️ Required: ")
                        +
                        Text("Body Fat Percentage")
                    }
                }
                Section {
                    ZStack {
                        Color.clear
                        Text(self.ⓕomulaDescription)
                            .multilineTextAlignment(.trailing)
                    }
                    .padding(8)
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

private struct 🛠ReminderMenuLink: View {
    @EnvironmentObject var 📱: 📱AppModel
    @State private var 🚩alertSettingDelied: Bool = false
    var body: some View {
        NavigationLink {
            List {
                Section {
                    Toggle(isOn: $📱.🚩ableReminder) {
                        Label("Reminder notification", systemImage: "bell")
                    }
                    .onChange(of: 📱.🚩ableReminder) {
                        if $0 == true { 📱.🔔setupNotification() }
                    }
                    Text("\"Number of days passed since last registration\" is displayed as a badge on this app icon.")
                    self.ⓔxampleNotificationBadge()
                } header: {
                    Text("Option")
                }
                Group {
                    Self.🄿eriodOfNonDisplaySection()
                    self.ⓑannerNotificationSection()
                }
                .disabled(!📱.🚩ableReminder)
                Section {
                    Text("Notified up to 50 days after your last registration.")
                } header: {
                    Text("Note")
                }
            }
            .navigationTitle("Reminder")
            .onChange(of: 📱.🚩ableReminder) { _ in
                self.ⓒheckAlertAboutAuthDenied()
                Task { await 📱.🔔refreshNotification() }
            }
            .onChange(of: 📱.🚩ableBannerNotification) { _ in Task { await 📱.🔔refreshNotification() } }
            .onChange(of: 📱.🔢periodOfNonDisplay) { _ in Task { await 📱.🔔refreshNotification() } }
            .alert("⚠️ Notification auth denied", isPresented: self.$🚩alertSettingDelied) { EmptyView() }
            .task { self.ⓒheckAlertAboutAuthDenied() }
        } label: {
            Label("Reminder notification", systemImage: "bell")
        }
    }
    private func ⓔxampleNotificationBadge() -> some View {
        ZStack {
            Color.clear
            VStack {
                Image("BadgeExample")
                    .cornerRadius(8)
                HStack(spacing: 4) {
                    Text("Example:")
                    Text(DateComponentsFormatter.localizedString(from: DateComponents(day: 7), unitsStyle: .full) ?? "+7")
                }
                .font(.footnote)
            }
        }
    }
    private func ⓒheckAlertAboutAuthDenied() {
        Task { @MainActor in
            self.🚩alertSettingDelied = await 📱.checkAlertAboutAuthDenied()
        }
    }
    private struct 🄿eriodOfNonDisplaySection: View {
        @EnvironmentObject var 📱: 📱AppModel
        private var ⓟeriodOfNonDisplay: Int { 📱.🔢periodOfNonDisplay }
        private var ⓛatestSampleDate: Date? { 📱.ⓛatestSampleDate[.bodyMass] }
        private let ⓓateFormat: Date.FormatStyle = .dateTime.day().month().hour().minute()
        private var ⓣimeOfDisplay: Date? {
            ⓛatestSampleDate?.addingTimeInterval(60 * 60 * 24 * Double(self.ⓟeriodOfNonDisplay))
        }
        var body: some View {
            Section {
                Stepper(value: $📱.🔢periodOfNonDisplay, in: 1...31) {
                    Label("Period of non-display", systemImage: "bell.slash")
                        .badge(DateComponentsFormatter.localizedString(from: .init(day: self.ⓟeriodOfNonDisplay),
                                                                       unitsStyle: .abbreviated))
                }
                if let ⓛatestSampleDate, let ⓣimeOfDisplay {
                    Group {
                        Text("Last sample's date")
                            .badge(ⓛatestSampleDate.formatted(self.ⓓateFormat))
                        Text("Time of display")
                            .badge(ⓣimeOfDisplay.formatted(self.ⓓateFormat) + "~")
                    }
                    .monospacedDigit()
                    .foregroundStyle(.primary)
                }
            } header: {
                Text("Period of display")
            }
        }
    }
    private func ⓑannerNotificationSection() -> some View {
        Section {
            Toggle(isOn: $📱.🚩ableBannerNotification) {
                Label("With daily banner notification", systemImage: "platter.filled.top.and.arrow.up.iphone")
            }
            ZStack {
                Color.clear
                Image("BannerExample")
                    .cornerRadius(8)
            }
        } header: {
            Text("Banner notification")
        }
    }
}
