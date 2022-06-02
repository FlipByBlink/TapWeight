
import SwiftUI


struct 🕛HistorySection: View {
    
    @EnvironmentObject var 📱:📱Model
    
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
