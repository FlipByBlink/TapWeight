
let 🔗AppStoreProductURL = URL(string: "https://apps.apple.com/app/id1624159721")!

let 👤PrivacyPolicy = """
2022-05-22
                            
(English)This application don't collect user infomation.

(Japanese)このアプリ自身において、ユーザーの情報を一切収集しません。
"""


import SwiftUI

struct ℹ️AboutAppMenu: View {
    var body: some View {
        List {
            📰AppStoreDescriptionSection()
            🔗AppStoreLink()
            👤PrivacyPolicySection()
            🕒VersionHistoryLink()
            📓SourceCodeLink()
            🧑‍💻AboutDeveloperPublisherLink()
        }
        .navigationTitle("About App")
    }
}

struct 📰AppStoreDescriptionSection: View {
    var body: some View {
        Section {
            NavigationLink {
                ScrollView {
                    Text("📃", tableName: "🌏AppStoreDescription")
                        .padding()
                }
                .navigationBarTitle("Description")
                .navigationBarTitleDisplayMode(.inline)
                .textSelection(.enabled)
            } label: {
                Text("📃", tableName: "🌏AppStoreDescription")
                    .font(.subheadline)
                    .lineLimit(7)
                    .padding(8)
                    .accessibilityLabel("Description")
            }
        } header: { Text("Description") }
    }
}

struct 🔗AppStoreLink: View {
    var body: some View {
        Section {
            Link(destination: 🔗AppStoreProductURL) {
                HStack {
                    Label("Open AppStore page", systemImage: "link")
                    Spacer()
                    Image(systemName: "arrow.up.forward.app")
                }
            }
        } footer: {
            Text(🔗AppStoreProductURL.description)
        }
    }
}

struct 👤PrivacyPolicySection: View {
    var body: some View {
        Section {
            NavigationLink {
                Text(👤PrivacyPolicy)
                    .padding(32)
                    .textSelection(.enabled)
                    .navigationTitle("Privacy Policy")
            } label: {
                Label("Privacy Policy", systemImage: "person.text.rectangle")
            }
        }
    }
}
