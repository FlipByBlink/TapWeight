
import SwiftUI


struct MenuView: View { // ⚙️
    
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
        .accessibilityLabel("🌏Open menu")
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
                    
                    
                    🕛HistoryView()
                    
                    📄DocumentView()
                    
                    AdSection()
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


struct 🕛HistoryView: View {
    @AppStorage("history") var 🄷istory: String = ""
    
    var body: some View {
        Section {
            NavigationLink  {
                if 🄷istory == "" {
                    Image(systemName: "text.insert")
                        .foregroundStyle(.tertiary)
                        .font(.system(size: 64))
                        .navigationTitle("History")
                        .navigationBarTitleDisplayMode(.inline)
                } else {
                    ScrollView {
                        📄View(🄷istory, "History")
                            .toolbar {
                                ToolbarItem(placement: .navigationBarTrailing) {
                                    Button {
                                        🄷istory = ""
                                    } label: {
                                        Image(systemName: "trash")
                                            .tint(.red)
                                    }
                                }
                            }
                    }
                }
            } label: {
                Label("Local history (plain text)", systemImage: "clock")
            }
        }
    }
}


struct 📄DocumentView: View {
    var body: some View {
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
                    
                    Text("🌏About")
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
                
                
                Section {
                    NavigationLink {
                        Text("🌏TextAboutAD")
                            .padding()
                            .navigationTitle("🌏About self-AD")
                    } label: {
                        Label("🌏About self-AD", systemImage: "exclamationmark.bubble")
                            .font(.subheadline)
                    }
                }
                
                
                NavigationLink {
                    📓SourceCodeDoc()
                } label: {
                    Label("Source code", systemImage: "doc.plaintext")
                        .font(.subheadline)
                }
            }
            .navigationTitle("App Document")
        } label: {
            Label("App Document", systemImage: "doc")
        }
    }
}


struct 📓SourceCodeDoc: View {
    @Environment(\.dismiss) var 🔙: DismissAction
    
    var 📁URL: URL {
        Bundle.main.bundleURL.appendingPathComponent("📁")
    }
    
    var 📦: [String] {
        try! FileManager.default.contentsOfDirectory(atPath: 📁URL.path)
    }
    
    var body: some View {
        List {
            Section {
                ForEach(📦, id: \.self) { 📃 in
                    NavigationLink(📃) {
                        let 📍 = 📁URL.appendingPathComponent(📃)
                        ScrollView {
                            ScrollView(.horizontal, showsIndicators: false) {
                                📄View(try! String(contentsOf: 📍), 📃)
                            }
                        }
                    }
                }
            }
            
            
            📑BundleMainInfoDictionary()
            
            
            let 🔗HealthKit = "https://developer.apple.com/documentation/healthkit"
            Section {
                Link(destination: URL(string: 🔗HealthKit)!) {
                    HStack {
                        Label("HealthKit document link", systemImage: "link")
                        
                        Spacer()
                        
                        Image(systemName: "arrow.up.forward.app")
                    }
                }
            } footer: {
                Text(🔗HealthKit)
            }
            
            
            let Repository🔗 = "https://github.com/FlipByBlink/TapWeight"
            Section {
                Link(destination: URL(string: Repository🔗)!) {
                    HStack {
                        Label("Web Repository link", systemImage: "link")
                        
                        Spacer()
                        
                        Image(systemName: "arrow.up.forward.app")
                    }
                }
            } footer: {
                Text(Repository🔗)
            }
        }
        .navigationTitle("Source code")
    }
}


struct 📄View: View {
    var 📄: String
    
    var 🏷: String
    
    var body: some View {
        Text(📄)
            .navigationBarTitle(🏷)
            .navigationBarTitleDisplayMode(.inline)
            .font(.caption.monospaced())
            .padding()
            .textSelection(.enabled)
    }
    
    init(_ 📄: String, _ 🏷: String) {
        self.📄 = 📄
        self.🏷 = 🏷
    }
}


let 🄱undleMainInfoDictionary = Bundle.main.infoDictionary!.description
struct 📑BundleMainInfoDictionary: View {
    var body: some View {
        Section {
            NavigationLink("Bundle.main.infoDictionary") {
                ScrollView {
                    📄View(🄱undleMainInfoDictionary, "Bundle.main.infoDictionary")
                }
            }
        }
    }
}
