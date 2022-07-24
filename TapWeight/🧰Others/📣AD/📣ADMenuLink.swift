
import SwiftUI
import StoreKit

struct 📣ADMenuLink: View {
    @EnvironmentObject var 🛒: 🛒StoreModel
    
    var body: some View {
        Section {
            if 🛒.🚩Purchased == false {
                💸ADView()
            }
            
            NavigationLink {
                List {
                    Section {
                        Text("This App shows banner advertisement about applications on AppStore. These are Apps by TapWeight developer. AD banner is rarely presented on result screen. It appears one in every 4 times.")
                            .padding()
                    } header: {
                        Text("About")
                    }
                    
                    
                    🛒PurchaseSection()
                    
                    
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
}
