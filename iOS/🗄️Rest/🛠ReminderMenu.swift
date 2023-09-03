import SwiftUI

struct 🛠ReminderMenu: View {
    @EnvironmentObject var 📱: 📱AppModel
    @State private var 🚩alertSettingDelied: Bool = false
    var body: some View {
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
    }
}

private extension 🛠ReminderMenu {
    private func ⓔxampleNotificationBadge() -> some View {
        ZStack {
            Color.clear
            VStack {
                Image("BadgeExample")
                    .cornerRadius(8)
                HStack(spacing: 4) {
                    Text("Example:")
                    Text(RelativeDateTimeFormatter().localizedString(from: DateComponents(day: -7)))
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
