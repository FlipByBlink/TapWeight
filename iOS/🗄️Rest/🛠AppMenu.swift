import SwiftUI

struct 🛠MenuButton: View { // ⚙️
    @State private var showSheet: Bool = false
    var body: some View {
        Button {
            self.showSheet = true
        } label: {
            Label("Open menu", systemImage: "gearshape")
                .font(.body.weight(.medium))
        }
        .tint(.primary)
        .sheet(isPresented: self.$showSheet) { 🛠AppMenu() }
    }
}

private struct 🛠AppMenu: View {
    @EnvironmentObject var 📱: 📱AppModel
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationStack {
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
                self.aboutAppMenuLink()
                🛒InAppPurchaseMenuLink()
            }
            .navigationTitle("Menu")
            .toolbar { self.dismissButton() }
        }
    }
}

private extension 🛠AppMenu {
    private func dismissButton() -> some View {
        Button {
            self.dismiss()
            💥Feedback.light()
        } label: {
            Image(systemName: "xmark.circle.fill")
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(Color.secondary)
        }
    }
    private func aboutAppMenuLink() -> some View {
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
    }
}
