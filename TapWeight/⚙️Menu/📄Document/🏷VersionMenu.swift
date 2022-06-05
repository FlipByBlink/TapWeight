
import SwiftUI

struct 🏷VersionMenu: View {
    var body: some View {
        Section {
            NavigationLink {
                ScrollView {
                    📋TextView(🕒VersionHistory, "Version history")
                }
            } label: {
                Label("1.1" , systemImage: "signpost.left")
            }
        } header: {
            Text("Version")
        } footer: {
            let 📅 = Date.now.formatted(date: .numeric, time: .omitted)
            Text("builded on \(📅)")
        }
    }
}

let 🕒VersionHistory = """
                        🕒 Version 1.1 : (2022/06/05?)
                        
                        
                        
                        🕒 Version 1.0 : 2022/05/23
                        Initial release
                        """
