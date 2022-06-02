
import SwiftUI


struct 🕛HistorySection: View {
    @EnvironmentObject var 📱:📱Model
    
    var body: some View {
        Section {
            NavigationLink  {
                🕛HistoryView(🄷istory: $📱.🄷istory)
            } label: {
                Label("🌏Local history", systemImage: "clock")
            }
        } footer: {
            Text("🌏\"Local history\" is for the porpose of \"operation check\" / \"temporary backup\"")
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
