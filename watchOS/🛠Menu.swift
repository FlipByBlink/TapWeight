import SwiftUI

struct 🛠MenuButton: View {
    @State private var showSheet: Bool = false
    var body: some View {
        Section {
            Button {
                self.showSheet = true
                💥Feedback.light()
            } label: {
                HStack {
                    Spacer()
                    Label("Open menu", systemImage: "gear.circle.fill")
                        .labelStyle(.iconOnly)
                        .symbolRenderingMode(.hierarchical)
                        .font(.title2)
                    Spacer()
                }
            }
            .buttonStyle(.plain)
            .listRowBackground(Color.clear)
        }
        .sheet(isPresented: self.$showSheet) {
            🛠Menu()
        }
    }
}

private struct 🛠Menu: View {
    @EnvironmentObject var model: 📱AppModel
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationStack {
            List {
                Section {
                    Toggle(isOn: self.$model.🚩ableBMI) {
                        Label("Body Mass Index", systemImage: "function")
                    }
                    Toggle(isOn: self.$model.🚩ableBodyFat) {
                        Label("Body Fat Percentage", systemImage: "percent")
                    }
                    .onChange(of: self.model.🚩ableBodyFat) {
                        if $0 == false { self.model.🚩ableLBM = false }
                    }
                    Toggle(isOn: self.$model.🚩ableLBM) {
                        Label("Lean Body Mass", systemImage: "person.badge.minus")
                    }
                    .disabled(!self.model.🚩ableBodyFat)
                    .onChange(of: self.model.🚩ableLBM) {
                        if $0 == true { self.model.🚩ableBodyFat = true }
                    }
                    //Toggle(isOn: self.$model.🚩ableDatePicker) {
                    //    Label("Date picker", systemImage: "calendar.badge.clock")
                    //}
                    //.onChange(of: self.model.🚩ableDatePicker) { _ in
                    //    self.model.📅datePickerValue = .now
                    //}
                    if self.model.ⓜassUnit == .gramUnit(with: .kilo) {
                        Toggle(isOn: self.$model.🚩amount50g) {
                            Label("0.1kg → 0.05kg", systemImage: "minus.forwardslash.plus")
                        }
                        .accessibilityLabel("50gram")
                    }
                } header: {
                    Text("Option")
                }
                self.aboutAppMenuLink()
            }
            .navigationTitle("Menu")
        }
    }
}

private extension 🛠Menu {
    private func aboutAppMenuLink() -> some View {
        NavigationLink {
            ℹ️AboutAppMenu()
        } label: {
            Label(String(localized: "About App", table: "🌐AboutApp"),
                  systemImage: "doc")
        }
    }
}
