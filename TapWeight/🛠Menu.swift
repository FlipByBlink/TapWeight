
import SwiftUI


struct 🛠Menu: View { // ⚙️
    
    @State private var 🚩Menu: Bool = false
    
    @AppStorage("Unit") var 🛠Unit: 📏Enum = .kg
    
    @AppStorage("AbleBodyFat") var 🚩BodyFat: Bool = false
    
    @AppStorage("AbleBMI") var 🚩BMI: Bool = false
    
    @State private var 📝Height: Int = 170
    
    @AppStorage("Height") var 💾Height: Int = 165
    
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
                        Picker(selection: $🛠Unit) {
                            ForEach(📏Enum.allCases, id: \.self) { 🏷 in
                                Text(🏷.rawValue)
                            }
                        } label: {
                            Label("🌏Unit", systemImage: "scalemass")
                        }
                        
                        Toggle(isOn: $🚩BodyFat) {
                            Label("🌏Body Fat Percentage", systemImage: "percent")
                        }
                        
                        Toggle(isOn: $🚩BMI) {
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
                            📝Height = 💾Height
                        }
                        .onDisappear {
                            💾Height = 📝Height
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


struct 🕛HistorySection: View {
    @AppStorage("historyBodyMass") var 🄷istoryBodyMass: String = ""
    @AppStorage("historyBodyFat") var 🄷istoryBodyFat: String = ""
    @AppStorage("historyBMI") var 🄷istoryBMI: String = ""
    
    var body: some View {
        Section {
            NavigationLink {
                List {
                    Section {
                        NavigationLink  {
                            🕛HistoryView(🄷istory: $🄷istoryBodyMass)
                        } label: {
                            Label("🌏Body Mass", systemImage: "scalemass")
                        }
                        
                        NavigationLink  {
                            🕛HistoryView(🄷istory: $🄷istoryBodyFat)
                        } label: {
                            Label("🌏Body Fat Percentage", systemImage: "percent")
                        }
                        
                        NavigationLink  {
                            🕛HistoryView(🄷istory: $🄷istoryBMI)
                        } label: {
                            Label("🌏Body Mass Index", systemImage: "function")
                        }
                    } footer: {
                        Text("🌏\"Local history\" is for the porpose of \"operation check\" / \"temporary backup\"")
                    }
                }
                .navigationTitle("🌏Local history")
            } label: {
                Label("🌏Local history", systemImage: "clock")
            }
        }
    }
}


struct 🕛HistoryView: View {
    @Binding var 🄷istory: String
    
    var body: some View {
        if 🄷istory == "" {
            Image(systemName: "text.append")
                .foregroundStyle(.tertiary)
                .font(.system(size: 64))
                .navigationTitle("History")
                .navigationBarTitleDisplayMode(.inline)
        } else {
            ScrollView {
                ScrollView(.horizontal, showsIndicators: false) {
                    📄PageView(🄷istory, "History")
                        .toolbar {
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button {
                                    🄷istory = ""
                                } label: {
                                    Image(systemName: "trash")
                                        .tint(.red)
                                }
                            }
                        }
                }
            }
        }
    }
}
