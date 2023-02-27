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
                Picker(selection: $📱.📏massUnit) {
                    ForEach(📏BodyMassUnit.allCases) { Text($0.rawValue) }
                } label: {
                    Label("Unit", systemImage: "scalemass")
                }
                .onChange(of: 📱.📏massUnit) { _ in
                    📱.🚩amount50g = false
                }
                Toggle(isOn: $📱.🚩amount50g) {
                    Label("100g → 50g", systemImage: "minus.forwardslash.plus")
                        .padding(.leading)
                        .foregroundColor(📱.📏massUnit != .kg ? .secondary : nil)
                }
                .font(.subheadline)
                .disabled(📱.📏massUnit != .kg)
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
            ℹ️AboutAppLink()
            📣ADMenuLink()
        }
        .navigationTitle("Menu")
        .toolbar { ﹀CloseMenuButton(dismiss) }
        .onDisappear { 📱.🏥getLatestValue() }
    }
}

struct ℹ️AboutAppLink: View {
    var body: some View {
        Section {
            GeometryReader { 📐 in
                VStack(spacing: 12) {
                    Image("TapWeight")
                        .resizable()
                        .mask { RoundedRectangle(cornerRadius: 22.5, style: .continuous) }
                        .shadow(radius: 3, y: 1)
                        .frame(width: 100, height: 100)
                    VStack(spacing: 6) {
                        Text("TapWeight")
                            .font(.system(.title2, design: .rounded))
                            .fontWeight(.bold)
                            .tracking(1.5)
                            .opacity(0.75)
                            .lineLimit(1)
                            .minimumScaleFactor(0.1)
                        Text("Application for iPhone")
                            .font(.footnote)
                            .fontWeight(.medium)
                            .foregroundStyle(.secondary)
                    }
                    .lineLimit(1)
                    .minimumScaleFactor(0.1)
                }
                .padding(20)
                .padding(.top, 8)
                .frame(width: 📐.size.width)
            }
            .frame(height: 200)
            Link(destination: URL(string: "https://apps.apple.com/app/id1624159721")!) {
                HStack {
                    Label("Open AppStore page", systemImage: "link")
                    Spacer()
                    Image(systemName: "arrow.up.forward.app")
                        .imageScale(.small)
                        .foregroundStyle(.secondary)
                }
            }
            NavigationLink  {
                ℹ️AboutAppMenu()
            } label: {
                Label("About App", systemImage: "doc")
            }
        }
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
