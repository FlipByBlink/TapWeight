
import SwiftUI

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
                            .foregroundColor(📱.📏Unit == .kg ? .primary : .secondary)
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
                    
                    🧍HeightMenu()
                }
                
                
                Section {
                    Toggle(isOn: $📱.🚩AbleBodyFat) {
                        Label("Body Fat Percentage", systemImage: "percent")
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
                    
                    🕒LocalHistoryLink()
                }
                
                
                🛠OthersMenu()
            }
            .navigationTitle("TapWeight")
            .toolbar { ﹀CloseMenuButton($📱.🚩ShowMenu) }
        }
        .onDisappear { 📱.🚩ShowMenu = false }
    }
}
