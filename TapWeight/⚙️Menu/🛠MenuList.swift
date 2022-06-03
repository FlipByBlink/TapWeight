
import SwiftUI

struct 🛠MenuList: View {
    @EnvironmentObject var 📱:📱Model
    
    @Environment(\.dismiss) var 🔙: DismissAction
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    Picker(selection: $📱.💾BodyMassUnit) {
                        ForEach(📏BodyMassUnit.allCases, id: \.self) { 🏷 in
                            Text(🏷.rawValue)
                        }
                    } label: {
                        Label("🌏Unit", systemImage: "scalemass")
                    }
                    
                    Toggle(isOn: $📱.🚩BodyFat) {
                        Label("🌏Body Fat Percentage", systemImage: "percent")
                    }
                    
                    Toggle(isOn: $📱.🚩BMI) {
                        Label("🌏Body Mass Index", systemImage: "function")
                    }
                    
                    🧍HeightMenu()
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
                
                
                🕛HistorySection()
                
                
                Section {
                    📄DocumentMenu()
                }
                
                
                🗯AdSection()
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
