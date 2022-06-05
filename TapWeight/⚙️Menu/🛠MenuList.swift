
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
                    .listRowSeparator(.hidden, edges: .top)
                    .disabled(📱.📏Unit != .kg)
                    
                    Toggle(isOn: $📱.🚩AbleBMI) {
                        Label("🌏Body Mass Index", systemImage: "function")
                    }
                    
                    🧍HeightMenu()
                    
                    Toggle(isOn: $📱.🚩AbleBodyFat) {
                        Label("🌏Body Fat Percentage", systemImage: "percent")
                    }
                } header: {
                    Text("🌏Option")
                }
                
                
                Link (destination: URL(string: "x-apple-health://")!) {
                    HStack {
                        Label("🌏Open \"Health\" app", systemImage: "heart")
                        
                        Spacer()
                        
                        Image(systemName: "arrow.up.forward.app")
                    }
                    .font(.body.weight(.medium))
                }
                
                
                🕒HistoryMenu()
                
                
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




struct MenuList_Previews: PreviewProvider {
    static let 📱 = 📱Model()
    
    static var previews: some View {
        🛠MenuList()
            .environmentObject(📱)
    }
}
