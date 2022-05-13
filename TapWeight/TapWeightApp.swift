
import SwiftUI
import HealthKit


@main
struct TapWeightApp: App {
    
    @State private var 🚩Menu: Bool = false
    
    @AppStorage("AbleBodyFat") var 🚩BodyFat: Bool = false
    
    @AppStorage("LaunchHealthAppAfterLog") var 🚩LaunchHealthAppAfterLog: Bool = false
    
    @AppStorage("Unit") var 🛠Unit: EnumUnit = .kg
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .statusBar(hidden: true)
                .overlay(alignment: .bottomTrailing) {
                    Button {
                        🚩Menu = true
                    } label: {
                        Image(systemName: "gear")
                            .font(.largeTitle)
                            .foregroundStyle(.secondary)
                            .foregroundColor(.pink)
                            .padding(22)
                    }
                }
                .popover(isPresented: $🚩Menu) {
                    NavigationView {
                        List {
                            Section {
                                Toggle(isOn: $🚩BodyFat) {
                                    Label("Body fat percentage", systemImage: "percent")
                                }
                                
                                Toggle(isOn: $🚩LaunchHealthAppAfterLog) {
                                    Label("Show \"Health\" app after log", systemImage: "arrowshape.turn.up.right")
                                }
                                
                                Picker(selection: $🛠Unit) {
                                    ForEach(EnumUnit.allCases, id: \.self) { 🏷 in
                                        Text(🏷.rawValue)
                                    }
                                } label: {
                                    Label("Unit", systemImage: "scalemass")
                                }
                            } header: {
                                Text("Option")
                            }
                            
                            
                            Section {
                                Link(destination: URL(string: "x-apple-health://")!) {
                                    HStack {
                                        Label("Open Apple \"Health\" app", systemImage: "heart")
                                        
                                        Spacer()
                                        
                                        Image(systemName: "arrow.up.forward.app")
                                    }
                                    .font(.body.bold())
                                }
                            }
                        }
                        .navigationTitle("Log weight")
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
                                .accessibilityLabel("Dismiss")
                            }
                        }
                    }
                }
        }
    }
}


enum EnumUnit: String, CaseIterable {
    case kg
    case lbs
    case st
}
