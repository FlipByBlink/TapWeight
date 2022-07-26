
import SwiftUI
import StoreKit

struct 📣ADMenuLink: View {
    @EnvironmentObject var 🛒: 🛒StoreModel
    
    var body: some View {
        Section {
            if 🛒.🚩Purchased == false { 📣ADView() }
            
            NavigationLink {
                📣ADMenu()
            } label: {
                Label("About AD", systemImage: "megaphone")
            }
        }
    }
}

struct 📣ADMenu: View {
    @EnvironmentObject var 🛒: 🛒StoreModel
    
    var body: some View {
        List {
            Section {
                Text("This App shows banner advertisement about applications on AppStore. These are several Apps by this app's developer. It is activated after you launch this app 5 times.")
                    .padding()
                    .textSelection(.enabled)
            } header: { Text("About") }
            
            🛒PurchaseSection()
            
            Section {
                ForEach(📣AppName.allCases) { 🏷 in
                    📣ADView(🏷)
                }
            }
        }
        .navigationTitle("About AD")
    }
}
