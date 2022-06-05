
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
            ScrollView {
                ScrollView(.horizontal, showsIndicators: false) {
                    📋TextView(🕒History, "History")
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
}
