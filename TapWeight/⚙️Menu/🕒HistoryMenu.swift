
import SwiftUI

struct 🕒HistoryMenu: View {
    @EnvironmentObject var 📱:📱Model
    
    var body: some View {
        NavigationLink  {
            🕒HistoryView(🕒History: $📱.🕒History)
        } label: {
            Label("Local history", systemImage: "clock")
        }
    }
}


struct 🕒HistoryView: View {
    @Binding var 🕒History: String
    
    var body: some View {
        if 🕒History == "" {
            Image(systemName: "text.append")
                .foregroundStyle(.tertiary)
                .font(.system(size: 64))
                .navigationTitle("History")
                .navigationBarTitleDisplayMode(.inline)
        } else {
            VStack (spacing: 0) {
                Text("\"Local history\" is for the porpose of \"operation check\" / \"temporary backup\"")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .padding(24)
                
                Color.primary
                    .frame(height: 0.33)
                📋TextView(🕒History, "History", ⓗorizonScroll: true)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button {
                                🕒History = ""
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
