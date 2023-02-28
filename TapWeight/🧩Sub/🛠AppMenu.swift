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
                Toggle(isOn: $📱.🚩amount50g) {
                    Label("100g → 50g", systemImage: "minus.forwardslash.plus")
                        .padding(.leading)
//                        .foregroundColor(📱.📏massUnit != .kg ? .secondary : nil)
                }
                .font(.subheadline)
//                .disabled(📱.📏massUnit != .kg)
                .accessibilityLabel("50gram")
            } header: {
                Text("Option")
            }
            Section {
                Toggle(isOn: $📱.🚩ableBMI) {
                    Label("Body Mass Index", systemImage: "function")
                }
                .onChange(of: 📱.🚩ableBMI) {
                    if $0 == true { 📱.🏥requestAuth(.bodyMassIndex) }
                }
                🧍HeightMenuLink()
            }
            Section {
                Toggle(isOn: $📱.🚩ableBodyFat) {
                    Label("Body Fat Percentage", systemImage: "percent")
                }
                .onChange(of: 📱.🚩ableBodyFat) {
                    if $0 == true { 📱.🏥requestAuth(.bodyFatPercentage) }
                }
            }
            Section {
                Toggle(isOn: $📱.🚩ableDatePicker) {
                    Label("Date picker", systemImage: "calendar.badge.clock")
                }
                .onChange(of: 📱.🚩ableDatePicker) { _ in
                    📱.📅pickerValue = .now
                }
            }
            Section {
                Link (destination: URL(string: "x-apple-health://")!) {
                    HStack {
                        Label {
                            Text("Open \"Health\" app")
                        } icon: {
                            Image(systemName: "app")
                                .overlay {
                                    Image(systemName: "heart")
                                        .scaleEffect(0.55)
                                        .font(.body.bold())
                                }
                                .imageScale(.large)
                        }
                        Spacer()
                        Image(systemName: "arrow.up.forward.app")
                            .imageScale(.small)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            ℹ️AboutAppLink(name: "TapWeight", subtitle: "App for iPhone / Apple Watch")
            📣ADMenuLink()
        }
        .navigationTitle("Menu")
        .toolbar { ﹀CloseMenuButton(dismiss) }
    }
}

struct ﹀CloseMenuButton: View {
    private var 🔙dismiss: DismissAction
    var body: some View {
        Button {
            🔙dismiss()
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        } label: {
            Image(systemName: "chevron.down")
                .foregroundStyle(.secondary)
                .grayscale(1.0)
                .padding(8)
        }
        .accessibilityLabel("Dismiss")
    }
    init(_ 🔙dismiss: DismissAction) {
        self.🔙dismiss = 🔙dismiss
    }
}
