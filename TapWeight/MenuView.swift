
import SwiftUI


struct MenuView: View { // ⚙️
    
    @State private var 🚩Menu: Bool = false
    
    @AppStorage("AbleBodyFat") var 🚩BodyFat: Bool = false
    
    @AppStorage("AbleBMI") var 🚩BMI: Bool = false
    
    @AppStorage("LaunchHealthAppAfterLog") var 🚩LaunchHealthAppAfterLog: Bool = false
    
    
    @State private var 📝Height: Int = 170
    
    @AppStorage("Height") var 💾Height: Int = 165
    
    
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
                        Picker(selection: $🛠Unit) {
                            ForEach(🄴numUnit.allCases, id: \.self) { 🏷 in
                                Text(🏷.rawValue)
                            }
                        } label: {
                            Label("🌏Unit", systemImage: "scalemass")
                        }
                        
                        Toggle(isOn: $🚩LaunchHealthAppAfterLog) {
                            Label("🌏Show \"Health\" app after log", systemImage: "arrowshape.turn.up.right")
                        }
                        
                        Toggle(isOn: $🚩BodyFat) {
                            Label("🌏Body Fat Percentage", systemImage: "percent")
                        }
                        
                        Toggle(isOn: $🚩BMI) {
                            Label("🌏Body Mass Index", systemImage: "function")
                        }
                        
                        Stepper {
                            HStack {
                                Label("🌏Height", systemImage: "ruler")
                                
                                Text(📝Height.description + " cm")
                            }
                            .monospacedDigit()
                        } onIncrement: {
                            📝Height += 1
                        } onDecrement: {
                            📝Height -= 1
                        }
                        .onAppear {
                            📝Height = 💾Height
                        }
                        .onDisappear {
                            💾Height = 📝Height
                        }
                        .listRowSeparator(.hidden)
                        .scaleEffect(0.9, anchor: .trailing)
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
                    
                    🗯AdSection()
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
                    Image(systemName: "text.append")
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
                Label("🌏Local history (plain text)", systemImage: "clock")
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
                    
                    Text("""
                    Tool for fastest and most comfortable recording body weight to Apple Health app.
                    
                    【OPTION】
                    - With body fat percentage.
                    - With body mass index automatically.
                    - Automatically launch Apple Health app after record.
                    - Unit: kg, lbs, st
                    - Local history as plain text.
                    - Check source code in app.
                    """)
                    .font(.subheadline)
                    .padding(8)
                    .textSelection(.enabled)
                    
                    Text("""
                    # Japanese(native)
                    Appleヘルスケアアプリに体重を最速で登録するためのアプリです。
                    
                    【オプション】
                    - 体脂肪率も登録。
                    - 自動的にBMIも同時に登録。
                    - データ登録後に自動的にAppleヘルスケアアプリを立ち上げ。
                    - 単位: kg, lbs, st
                    - 端末内での履歴(プレーンテキスト)
                    - アプリ内でアプリ自身のソースコードを確認。
                    """)
                    .font(.subheadline)
                    .padding(8)
                    .textSelection(.enabled)
                    
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
                    .textSelection(.enabled)
                } header: {
                    Text("Privacy Policy")
                }
                
                
                Section {
                    NavigationLink {
                        Text("🌏TextAboutAD")
                            .padding()
                            .navigationTitle("🌏About self-AD")
                            .textSelection(.enabled)
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
