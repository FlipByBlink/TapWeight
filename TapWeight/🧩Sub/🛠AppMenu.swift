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
                    .accessibilityLabel("50gram")
                }
                🛠ReminderMenuLink()
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

private struct 🛠ReminderMenuLink: View {
    @EnvironmentObject var 📱: 📱AppModel
    private var ⓓelayCount: Int { 📱.🔢delayReminderDaysCount }
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
                    HStack {
                        Spacer()
                        Image(systemName: "app.badge")
                        Image(systemName: "platter.filled.top.and.arrow.up.iphone")
                        Spacer()
                    }.badge("Placeholder")
                } header: {
                    Text("Option")
                }
                Group {
                    Section {
                        Stepper(value: $📱.🔢delayReminderDaysCount, in: 1...31) {
                            Label("Delay days", systemImage: "bell.slash")
                                .badge(self.ⓓelayCount)
                        }
                        if let ⓜassLatestSampleDate = 📱.ⓜassLatestSampleDate {
                            Group {
                                Label("Last sample", systemImage: "calendar.badge.plus")
                                    .badge(ⓜassLatestSampleDate.formatted(.dateTime.day().month().hour()))
                                Label("Activation", systemImage: "calendar.badge.exclamationmark")
                                    .badge (ⓜassLatestSampleDate.addingTimeInterval(60 * 60 * 24 * Double(self.ⓓelayCount)).formatted(.dateTime.day().month()) + "~")
                            }
                            .monospacedDigit()
                            .padding(.leading, 12)
                        }
                    }
                    Section {
                        Toggle(isOn: $📱.🚩ableBannerReminder) {
                            Label("Banner notification", systemImage: "platter.filled.top.and.arrow.up.iphone")
                        }
                        DatePicker(selection: $📱.🕒ReminderHour, displayedComponents: .hourAndMinute) {
                            Label("Repeat hour", systemImage: "clock.arrow.circlepath")
                        }
                    }
                }
                .disabled(!📱.🚩ableReminder)
                NavigationLink("Detail") {
                    Self.🄳etailNotifications()
                }
            }
            .navigationTitle("Reminder")
        } label: {
            Label("Reminder notification", systemImage: "bell")
        }
    }
    struct 🄳etailNotifications: View {
        @EnvironmentObject var 📱: 📱AppModel
        @State private var ⓓeliveredNotifications: [UNNotification] = []
        @State private var ⓟendingNotificationRequests: [UNNotificationRequest] = []
        var body: some View {
            List {
                Section {
                    ForEach(self.ⓟendingNotificationRequests, id: \.identifier) { ⓡequest in
                        if let ⓣrigger = ⓡequest.trigger as? UNTimeIntervalNotificationTrigger {
                            VStack(alignment: .leading) {
                                Text("__badge__: \(ⓡequest.content.badge ?? 0)")
                                Text("__nextTriggerDate:__ \((ⓣrigger.nextTriggerDate()?.formatted() ?? "?"))")
                                Text("__timeInterval:__ \((ⓣrigger.timeInterval/(60*60*24)).description) * 60 * 60 * 24")
                            }
                        }
                    }
                } header: {
                    Text("pendingNotificationRequests")
                }
                Section {
                    ForEach(self.ⓓeliveredNotifications, id: \.description) { ⓝ in
                        VStack {
                            Text(ⓝ.request.identifier)
                            Text(ⓝ.date.formatted(date: .numeric, time: .omitted))
                            Text(ⓝ.request.content.badge?.description ?? "no badge")
                        }
                    }
                } header: {
                    Text("deliveredNotifications")
                }
            }
            .navigationTitle("Detail")
            .task {
                self.ⓓeliveredNotifications = await 📱.🔔notification.deliveredNotifications()
                self.ⓟendingNotificationRequests = await 📱.🔔notification.pendingNotificationRequests()
            }
        }
    }
}
