
import SwiftUI


struct 🛠Menu: View { // ⚙️
    @EnvironmentObject var 📱:📱Model
    
    @State private var 🚩Menu: Bool = false
    
    @State private var 📝Height: Int = 170
    
    var body: some View {
        Button {
            🚩Menu = true
        } label: {
            Image(systemName: "gear")
                .font(.largeTitle)
                .foregroundStyle(.secondary)
                .foregroundColor(.pink)
                .padding(24)
        }
        .accessibilityLabel("🌏Open menu")
        .sheet(isPresented: $🚩Menu) {
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
                        
                        Stepper {
                            HStack {
                                Label("🌏Height", systemImage: "ruler")
                                
                                Text(📝Height.description + " cm")
                            }
                            .monospacedDigit()
                        } onIncrement: {
                            📝Height += 1
                        } onDecrement: {
                            📝Height -= 1
                        }
                        .onAppear {
                            📝Height = 📱.💾Height
                        }
                        .onDisappear {
                            📱.💾Height = 📝Height
                        }
                        .listRowSeparator(.hidden)
                        .scaleEffect(0.9, anchor: .trailing)
                    } header: {
                        Text("🌏Option")
                    } footer: {
                        Text("🌏BMI = Weight(kg) / { Height(m) × Height(m) }")
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
                            🚩Menu = false
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
}
