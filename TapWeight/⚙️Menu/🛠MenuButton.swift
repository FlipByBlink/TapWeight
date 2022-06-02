
import SwiftUI


struct 🛠MenuButton: View { // ⚙️
    @State private var 🚩Menu: Bool = false
    
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
            🛠MenuList()
        }
    }
}


struct 🛠MenuList: View {
    @EnvironmentObject var 📱:📱Model
    
    @State private var 📝Height: Int = 170
    
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
                    
                    NavigationLink {
                        VStack (spacing: 48) {
                            Stepper {
                                Text(📝Height.description + " cm")
                                    .font(.system(size: 54).monospacedDigit())
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.1)
                            } onIncrement: {
                                📝Height += 1
                            } onDecrement: {
                                📝Height -= 1
                            }
                            .padding()
                            
                            HStack {
                                Text("BMI = ")
                                    .bold()
                                
                                VStack(spacing: 16) {
                                    Text("Weight(kg)")
                                    
                                    Text("Height(m) × Height(m)")
                                }
                                .padding()
                                .overlay {
                                    Rectangle()
                                        .frame(height: 2)
                                }
                            }
                            .font(.title3)
                        }
                        .padding()
                        .navigationTitle("🌏Height")
                        .onAppear {
                            📝Height = 📱.💾Height
                        }
                        .onDisappear {
                            📱.💾Height = 📝Height
                        }
                    } label: {
                        HStack {
                            Label("🌏Height", systemImage: "ruler")
                            
                            Spacer()
                            
                            Text(📱.💾Height.description + " cm")
                        }
                        .padding(.leading)
                        .foregroundStyle(.secondary)
                    }
                    .listRowSeparator(.hidden)
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
