
import SwiftUI

struct 🛠MenuButton: ToolbarContent { // ⚙️
    @Binding var 🚩ShowMenu: Bool
    
    var body: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button {
                🚩ShowMenu = true
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
            } label: {
                Image(systemName: "gearshape")
                    .foregroundColor(.primary)
            }
            .accessibilityLabel("Open menu")
            .sheet(isPresented: $🚩ShowMenu) {
                🛠AppMenu()
            }
        }
    }
    
    init(_ 🚩ShowMenu: Binding<Bool>) {
        _🚩ShowMenu = 🚩ShowMenu
    }
}


struct 🛠AppMenu: View {
    @EnvironmentObject var 📱: 📱AppModel
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    Picker(selection: $📱.📏Unit) {
                        ForEach(📏BodyMassUnit.allCases, id: \.self) { 🏷 in
                            Text(🏷.rawValue)
                        }
                    } label: {
                        Label("Unit", systemImage: "scalemass")
                    }
                    .onChange(of: 📱.📏Unit) { 📏 in
                        if 📏 != .kg {
                            📱.🚩Amount50g = false
                        }
                    }
                    
                    Toggle(isOn: $📱.🚩Amount50g) {
                        Label("100g → 50g", systemImage: "minus.forwardslash.plus")
                            .padding(.leading)
                            .foregroundColor(📱.📏Unit != .kg ? .secondary : nil)
                    }
                    .font(.subheadline)
                    .disabled(📱.📏Unit != .kg)
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
                                .foregroundStyle(.secondary)
                        }
                    }
                    
                    NavigationLink  {
                        🕒LocalHistoryView()
                    } label: {
                        Label("Local history", systemImage: "clock")
                    }
                }
                
                ℹ️AboutAppLink()
                📣ADMenuLink()
            }
            .navigationTitle("Menu")
            .toolbar { ﹀CloseMenuButton($📱.🚩ShowMenu) }
        }
        .onDisappear { 📱.🚩ShowMenu = false }
    }
}


struct 🕒LocalHistoryView: View {
    @EnvironmentObject var 📱: 📱AppModel
    
    var body: some View {
        VStack (spacing: 0) {
            if 📱.🕒History == "" {
                Spacer()
                
                Image(systemName: "text.append")
                    .foregroundStyle(.tertiary)
                    .font(.system(size: 64))
                    .navigationTitle("History")
                    .navigationBarTitleDisplayMode(.inline)
                
                Spacer()
            } else {
                ScrollView {
                    ScrollView(.horizontal, showsIndicators: false) {
                        Text(📱.🕒History)
                            .padding()
                    }
                }
                .navigationBarTitle("History")
                .navigationBarTitleDisplayMode(.inline)
                .font(.caption.monospaced())
                .textSelection(.enabled)
            }
            
            Color.secondary
                .frame(height: 0.4)
            
            Text("\"Local history\" is for the porpose of \"operation check\" / \"temporary backup\"")
                .font(.caption)
                .foregroundStyle(.secondary)
                .padding(24)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    📱.🕒History = ""
                } label: {
                    Image(systemName: "trash")
                        .tint(.red)
                }
            }
        }
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
                        .font(.title2)
                        .fontWeight(.medium)
                        .tracking(2)
                        .opacity(0.8)
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


struct ﹀CloseMenuButton: ToolbarContent {
    @Binding var 🚩ShowMenu: Bool
    
    var body: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button {
                🚩ShowMenu = false
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
    
    init(_ 🚩: Binding<Bool>) {
        _🚩ShowMenu = 🚩
    }
}
