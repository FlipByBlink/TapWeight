
import SwiftUI

struct 🛠MenuButton: View { // ⚙️
    @EnvironmentObject var 📱: 📱AppModel
    
    var body: some View {
        Button {
            📱.🚩ShowMenu = true
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        } label: {
            Image(systemName: "gearshape")
                .foregroundColor(.primary)
        }
        .accessibilityLabel("Open menu")
        .sheet(isPresented: $📱.🚩ShowMenu) {
            🛠AppMenu()
        }
    }
}

struct 🛠AppMenu: View {
    @EnvironmentObject var 📱: 📱AppModel
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    Picker(selection: $📱.📏MassUnit) {
                        ForEach(📏BodyMassUnit.allCases, id: \.self) { 🏷 in
                            Text(🏷.rawValue)
                        }
                    } label: {
                        Label("Unit", systemImage: "scalemass")
                    }
                    .onChange(of: 📱.📏MassUnit) { 📏 in
                        switch 📏 {
                            case .kg:
                                📱.📝MassValue = 60
                            case .lbs:
                                📱.📝MassValue = 130
                                📱.🚩Amount50g = false
                            case .st:
                                📱.📝MassValue = 10
                                📱.🚩Amount50g = false
                        }
                    }
                    
                    Toggle(isOn: $📱.🚩Amount50g) {
                        Label("100g → 50g", systemImage: "minus.forwardslash.plus")
                            .padding(.leading)
                            .foregroundColor(📱.📏MassUnit != .kg ? .secondary : nil)
                    }
                    .font(.subheadline)
                    .disabled(📱.📏MassUnit != .kg)
                    .accessibilityLabel("50gram")
                } header: {
                    Text("Option")
                }
                
                
                Section {
                    Toggle(isOn: $📱.🚩AbleBMI) {
                        Label("Body Mass Index", systemImage: "function")
                    }
                    
                    🧍HeightMenuLink()
                }
                
                
                Section {
                    Toggle(isOn: $📱.🚩AbleBodyFat) {
                        Label("Body Fat Percentage", systemImage: "percent")
                    }
                }
                
                
                Section {
                    Toggle(isOn: $📱.🚩AbleDatePicker) {
                        Label("Date picker", systemImage: "calendar.badge.clock")
                    }
                    .onChange(of: 📱.🚩AbleDatePicker) { _ in
                        📱.📅PickerValue = .now
                    }
                }
                
                
                Section {
                    Link (destination: URL(string: "x-apple-health://")!) {
                        HStack {
                            Image(systemName: "app")
                                .overlay {
                                    Image(systemName: "heart")
                                        .scaleEffect(0.55)
                                        .font(.body.bold())
                                }
                                .imageScale(.large)
                                .padding(.horizontal, 2)
                            Text("Open \"Health\" app")
                            Spacer()
                            Image(systemName: "arrow.up.forward.app")
                                .imageScale(.small)
                                .foregroundStyle(.secondary)
                        }
                    }
                    
                    NavigationLink  {
                        🕘LocalHistoryView()
                    } label: {
                        Label("Local history", systemImage: "clock")
                    }
                }
                
                ℹ️AboutAppLink()
                📣ADMenuLink()
            }
            .navigationTitle("Menu")
            .toolbar { ﹀CloseMenuButton() }
        }
        //.onDisappear { 📱.🚩ShowMenu = false }
        //modalをスワイプダウンで閉じた際に他のmodalに影響を与える不具合に対応するためのコード。
        //一旦コメントアウトしたが再び誤動作が起きないか注視する。
    }
}


struct ℹ️AboutAppLink: View {
    var body: some View {
        Section {
            ZStack {
                Color.clear
                
                VStack(spacing: 12) {
                    Image("TapWeight")
                        .resizable()
                        .mask {
                            RoundedRectangle(cornerRadius: 22.5, style: .continuous)
                        }
                        .shadow(radius: 3, y: 1)
                        .frame(width: 100, height: 100)
                    
                    Text("TapWeight")
                        .font(.system(.title2, design: .rounded))
                        .fontWeight(.medium)
                        .tracking(1.5)
                        .opacity(0.75)
                        .lineLimit(1)
                        .minimumScaleFactor(0.1)
                }
                .padding(24)
                .padding(.top, 12)
            }
            
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
    @EnvironmentObject var 📱: 📱AppModel
    
    var body: some View {
        Button {
            📱.🚩ShowMenu = false
            UISelectionFeedbackGenerator().selectionChanged()
        } label: {
            Image(systemName: "chevron.down")
                .foregroundStyle(.secondary)
                .grayscale(1.0)
                .padding(8)
        }
        .accessibilityLabel("Dismiss")
    }
}
