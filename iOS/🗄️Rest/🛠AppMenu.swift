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
                NavigationLink {
                    🛠BMIMenu()
                } label: {
                    Label("Body Mass Index", systemImage: "function")
                }
                Toggle(isOn: $📱.🚩ableBodyFat) {
                    Label("Body Fat Percentage", systemImage: "percent")
                }
                .onChange(of: 📱.🚩ableBodyFat) {
                    if $0 == false { 📱.🚩ableLBM = false }
                }
                NavigationLink {
                    🛠LBMMenu()
                } label: {
                    Label("Lean Body Mass", systemImage: "person.badge.minus")
                }
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
                NavigationLink {
                    🛠ReminderMenu()
                } label: {
                    Label("Reminder notification", systemImage: "bell")
                }
            } header: {
                Text("Option")
            }
            .onChange(of: 📱.ⓒontext) { $0.sendToWatchApp() }
            💟OpenHealthAppButton.onMenuView()
            Section {
                ℹ️IconAndName()
                ℹ️AppStoreLink()
                NavigationLink {
                    List { ℹ️AboutAppContent() }
                        .navigationTitle(String(localized: "About App", table: "🌐AboutApp"))
                } label: {
                    Label(String(localized: "About App", table: "🌐AboutApp"),
                          systemImage: "doc")
                }
            }
            🛒InAppPurchaseMenuLink()
        }
        .navigationTitle("Menu")
    }
}
