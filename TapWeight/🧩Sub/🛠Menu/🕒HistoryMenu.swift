
import SwiftUI

struct 🕒HistoryMenu: View {
    @EnvironmentObject var 📱: 📱AppModel
    
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
        VStack (spacing: 0) {
            if 🕒History == "" {
                Spacer()
                
                Image(systemName: "text.append")
                    .foregroundStyle(.tertiary)
                    .font(.system(size: 64))
                    .navigationTitle("History")
                    .navigationBarTitleDisplayMode(.inline)
                
                Spacer()
            } else {
                ScrollView {
                    ScrollView(.horizontal, showsIndicators: false) {
                        Text(🕒History)
                            .padding()
                    }
                }
                .navigationBarTitle("History")
                .navigationBarTitleDisplayMode(.inline)
                .font(.caption.monospaced())
                .textSelection(.enabled)
            }
                
            Color.secondary
                .frame(height: 0.4)
            
            Text("\"Local history\" is for the porpose of \"operation check\" / \"temporary backup\"")
                .font(.caption)
                .foregroundStyle(.secondary)
                .padding(24)
        }
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
