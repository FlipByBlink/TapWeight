
import SwiftUI


struct MenuButton: View { // ⚙️
    
    @State private var 🚩Menu: Bool = false
    
    @AppStorage("AbleBodyFat") var 🚩BodyFat: Bool = false
    
    @AppStorage("LaunchHealthAppAfterLog") var 🚩LaunchHealthAppAfterLog: Bool = false
    
    @AppStorage("Unit") var 🛠Unit: 🄴numUnit = .kg
    
    var body: some View {
        Button {
            🚩Menu = true
        } label: {
            Image(systemName: "gear")
                .font(.largeTitle)
                .foregroundStyle(.secondary)
                .foregroundColor(.pink)
                .padding(22)
        }
        .accessibilityLabel("Document")
        .sheet(isPresented: $🚩Menu) {
            
            NavigationView {
                List {
                    Section {
                        Toggle(isOn: $🚩BodyFat) {
                            Label("🌏Body fat percentage", systemImage: "percent")
                        }
                        
                        Toggle(isOn: $🚩LaunchHealthAppAfterLog) {
                            Label("🌏Show \"Health\" app after log", systemImage: "arrowshape.turn.up.right")
                        }
                        
                        Picker(selection: $🛠Unit) {
                            ForEach(🄴numUnit.allCases, id: \.self) { 🏷 in
                                Text(🏷.rawValue)
                            }
                        } label: {
                            Label("🌏Unit", systemImage: "scalemass")
                        }
                    } header: {
                        Text("🌏Option")
                    }
                    
                    
                    Section {
                        Link(destination: URL(string: "x-apple-health://")!) {
                            HStack {
                                Label("🌏Open Apple \"Health\" app", systemImage: "heart")
                                
                                Spacer()
                                
                                Image(systemName: "arrow.up.forward.app")
                            }
                            .font(.body.bold())
                        }
                    }
                    
                    NavigationLink {
                        List {
                            Section {
                                let 🔗 = "https://apps.apple.com/developer/id1347562710"
                                Link(destination: URL(string: 🔗)!) {
                                    HStack {
                                        Label("Open AppStore page", systemImage: "link")
                                        
                                        Spacer()
                                        
                                        Image(systemName: "arrow.up.forward.app")
                                    }
                                }
                                .font(.subheadline)
                                
                                Text("""
                                    placeholder
                                    """)
                                .font(.subheadline)
                                .padding(8)
                                
                                Label("version 1.0", systemImage: "signpost.left")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            } header: {
                                Text("About")
                            }
                            
                            Section {
                                Text("""
                                    2022-05-13
                                    (English)This application don't collect user infomation.
                                    (Japanese)このアプリ自身において、ユーザーの情報を一切収集しません。
                                    """)
                                .font(.subheadline)
                                .padding(8)
                            } header: {
                                Text("Privacy Policy")
                            }
                            
                            NavigationLink {
                                Text("placeholder") //📓SourceCodeDoc()
                            } label: {
                                Label("Source code", systemImage: "doc.plaintext")
                            }
                        }
                        .navigationTitle("Document")
                    } label: {
                        Label("Document", systemImage: "doc")
                    }
                }
                .navigationTitle("🌏TapWeight")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            🚩Menu = false
                        } label: {
                            Image(systemName: "chevron.down")
                                .foregroundStyle(.secondary)
                                .grayscale(1.0)
                                .padding(8)
                        }
                        .accessibilityLabel("🌏Dismiss")
                    }
                }
            }
        }
    }
}
