
import SwiftUI
import StoreKit

struct 💸AboutADView: View {
    var body: some View {
        NavigationLink {
            List {
                Section {
                    Text("This App shows banner advertisement about applications on AppStore. These are Apps by AAAA developer. AD banner is rarely presented on AAAA screen. It appears one in every AAAA times.") //TODO: Edit
                        .padding()
                } header: {
                    Text("About")
                }
                
                
                🏬PurchaseSection()
                
                
                Section {
                    ForEach(💸AppName.allCases) { 🏷 in
                        💸ADView(🏷)
                    }
                }
            }
            .navigationTitle("self-AD")
        } label: {
            Label("About AD", systemImage: "exclamationmark.bubble")
        }
    }
}
