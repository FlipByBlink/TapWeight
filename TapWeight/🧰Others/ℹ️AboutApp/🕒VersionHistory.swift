
let 🕒VersionNumber = "1.3"

let 🕒PastVersion: [(ⓝumber: String, ⓓate: String)] = [("1.2","2022-07-30"),
                                                       ("1.1.1","2022-06-22"),
                                                       ("1.1","2022-06-06"),
                                                       ("1.0","2022-05-23")]

import SwiftUI

struct 🕒VersionHistoryLink: View {
    var body: some View {
        Section {
            NavigationLink {
                List {
                    Section {
                        Text(LocalizedStringKey(🕒VersionNumber), tableName: "🌏VersionDescription")
                            .font(.subheadline)
                            .padding()
                    } header: {
                        Text(🕒VersionNumber)
                    } footer: {
                        let 📅 = Date.now.formatted(date: .long, time: .omitted)
                        Text("builded on \(📅)")
                    }
                    .headerProminence(.increased)
                    
                    
                    🕒PastVersionSection()
                }
                .navigationBarTitle("Version History")
                .navigationBarTitleDisplayMode(.inline)
                .textSelection(.enabled)
            } label: {
                Label(🕒VersionNumber, systemImage: "signpost.left")
            }
            .accessibilityLabel("Version History")
        } header: {
            Text("Version")
        }
    }
}

struct 🕒PastVersionSection: View {
    var body: some View {
        ForEach(🕒PastVersion, id: \.self.ⓝumber) { 📃 in
            Section {
                Text(LocalizedStringKey(📃.ⓝumber), tableName: "🌏VersionDescription")
                    .font(.subheadline)
                    .padding()
            } header: {
                Text(📃.ⓝumber)
            } footer: {
                Text(📃.ⓓate)
            }
            .headerProminence(.increased)
        }
    }
}
