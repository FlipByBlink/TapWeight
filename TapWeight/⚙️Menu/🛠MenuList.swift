
import SwiftUI

struct 🛠MenuList: View {
    @EnvironmentObject var 📱:📱Model
    
    @Environment(\.dismiss) var 🔙: DismissAction
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    Picker(selection: $📱.📏Unit) {
                        ForEach(📏BodyMassUnit.allCases, id: \.self) { 🏷 in
                            Text(🏷.rawValue)
                        }
                    } label: {
                        Label("🌏Unit", systemImage: "scalemass")
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
                } header: {
                    Text("🌏Option")
                }
                 
                Section {
                    Toggle(isOn: $📱.🚩AbleBMI) {
                        Label("🌏Body Mass Index", systemImage: "function")
                    }
                    
                    🧍HeightMenu()
                }
                
                Section {
                    Toggle(isOn: $📱.🚩AbleBodyFat) {
                        Label("🌏Body Fat Percentage", systemImage: "percent")
                    }
                }
                
                Section {
                    Link (destination: URL(string: "x-apple-health://")!) {
                        HStack {
                            Label("🌏Open \"Health\" app", systemImage: "heart")
                            
                            Spacer()
                            
                            Image(systemName: "arrow.up.forward.app")
                        }
                    }
                    
                    🕒HistoryMenu()
                } footer: {
                    Text("🌏\"Local history\" is for the porpose of \"operation check\" / \"temporary backup\"")
                }
                
                Section {
                    📄DocumentMenu()
                }
                
                💸AdSection()
            }
            .navigationTitle("🌏TapWeight")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        🔙.callAsFunction()
                    } label: {
                        Image(systemName: "chevron.down")
                            .foregroundStyle(.secondary)
                            .grayscale(1.0)
                            .padding(8)
                    }
                    .accessibilityLabel("🌏Dismiss")
                }
            }
        }
    }
}
