
import SwiftUI


struct 🛠Menu: View { // ⚙️
    
    @State private var 🚩Menu: Bool = false
    
    @AppStorage("Unit") var 🛠Unit: 📏Enum = .kg
    
    @AppStorage("AbleBodyFat") var 🚩BodyFat: Bool = false
    
    @AppStorage("AbleBMI") var 🚩BMI: Bool = false
    
    @State private var 📝Height: Int = 170
    
    @AppStorage("Height") var 💾Height: Int = 165
    
    var body: some View {
        Button {
            🚩Menu = true
        } label: {
            Image(systemName: "gear")
                .font(.largeTitle)
                .foregroundStyle(.secondary)
                .foregroundColor(.pink)
        }
        .accessibilityLabel("🌏Open menu")
        .sheet(isPresented: $🚩Menu) {
            NavigationView {
                List {
                    Section {
                        Picker(selection: $🛠Unit) {
                            ForEach(📏Enum.allCases, id: \.self) { 🏷 in
                                Text(🏷.rawValue)
                            }
                        } label: {
                            Label("🌏Unit", systemImage: "scalemass")
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
                    } footer: {
                        Text("🌏BMI = Weight(kg) / { Height(m) × Height(m) }")
                    }
                    
                    🕛HistorySection()
                    
                    Section {
                        📄DocumentMenu()
                    }
                    
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


struct 🕛HistorySection: View {
    @AppStorage("historyBodyMass") var 🄷istoryBodyMass: String = ""
    @AppStorage("historyBodyFat") var 🄷istoryBodyFat: String = ""
    @AppStorage("historyBMI") var 🄷istoryBMI: String = ""
    
    var body: some View {
        Section {
            NavigationLink {
                List {
                    Section {
                        NavigationLink  {
                            🕛HistoryView(🄷istory: $🄷istoryBodyMass)
                        } label: {
                            Label("🌏Body Mass", systemImage: "scalemass")
                        }
                        
                        NavigationLink  {
                            🕛HistoryView(🄷istory: $🄷istoryBodyFat)
                        } label: {
                            Label("🌏Body Fat Percentage", systemImage: "percent")
                        }
                        
                        NavigationLink  {
                            🕛HistoryView(🄷istory: $🄷istoryBMI)
                        } label: {
                            Label("🌏Body Mass Index", systemImage: "function")
                        }
                    } footer: {
                        Text("🌏\"Local history\" is for the porpose of \"operation check\" / \"temporary backup\"")
                    }
                }
                .navigationTitle("🌏Local history")
            } label: {
                Label("🌏Local history", systemImage: "clock")
            }
        }
    }
}


struct 🕛HistoryView: View {
    @Binding var 🄷istory: String
    
    var body: some View {
        if 🄷istory == "" {
            Image(systemName: "text.append")
                .foregroundStyle(.tertiary)
                .font(.system(size: 64))
                .navigationTitle("History")
                .navigationBarTitleDisplayMode(.inline)
        } else {
            ScrollView {
                ScrollView(.horizontal, showsIndicators: false) {
                    📄PageView(🄷istory, "History")
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
        }
    }
}


struct 📄DocumentMenu: View {
    var body: some View {
        NavigationLink {
            List {
                Section {
                    Label("1.0" , systemImage: "signpost.left")
                } header: {
                    Text("Version")
                } footer: {
                    let 📅 = Date.now.formatted(date: .numeric, time: .omitted)
                    Text("builded on \(📅)")
                }
                
                
                Section {
                    NavigationLink {
                        ScrollView {
                            📄PageView(📄AboutEN, "About app")
                        }
                    } label: {
                        Text(📄AboutEN)
                            .font(.subheadline)
                            .lineLimit(7)
                            .padding(8)
                    }
                    
                    NavigationLink {
                        ScrollView {
                            📄PageView(📄AboutJA, "アプリのついて")
                        }
                    } label: {
                        Text(📄AboutJA)
                            .font(.subheadline)
                            .lineLimit(7)
                            .padding(8)
                    }
                } header: {
                    Text("About")
                }
                
                
                let 🔗 = "https://apps.apple.com/developer/id1347562710"
                Section {
                    Link(destination: URL(string: 🔗)!) {
                        HStack {
                            Label("Open AppStore page", systemImage: "link")
                            
                            Spacer()
                            
                            Image(systemName: "arrow.up.forward.app")
                        }
                    }
                } footer: {
                    Text(🔗)
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
                    }
                }
                
                
                NavigationLink {
                    📓SourceCodeDoc()
                } label: {
                    Label("Source code", systemImage: "doc.plaintext")
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
                                📄PageView(try! String(contentsOf: 📍), 📃)
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


struct 📄PageView: View {
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
                    📄PageView(🄱undleMainInfoDictionary, "Bundle.main.infoDictionary")
                }
            }
        }
    }
}


let 📄AboutEN = """
                    This application is designed to register weight data to the Apple "Health" application pre-installed on iPhone in the fastest possible way (as manual).
                    
                    People frequently measure their weight and body fat percentage daily using a scale. Many iPhone users register their weight and body fat percentage data on "Health" app. The best solution is to use a smart scale that works with "Health" app and automatically stores measurements, but they are expensive and inaccessible. Manual data registration is possible in "Health" app, but "Health" app is not designed for daily manual data registration. Therefore, manually entering data that occurs continuously daily, such as weight measurements, is a very time-consuming and stressful experience. This app was developed to solve such problems.
                    
                    This app cannot read, view, or manage past data in "Health" app. This app is intended only to register data to the "Health" app. Please check the registered data on the "Health" app.
                    
                    【OPTION】
                    - With body fat percentage.
                    - With body mass index automatically.
                    - Unit: kg, lbs, st
                    
                    【OTHERS】
                    - Launch "Health" app by one tap.
                    - Local history for the porpose of "operation check" / "temporary backup".
                    - Check source code in app.
                    - All feature is free.
                    - Rarely appear AD banner of app by TapWeight developer.
                    """

let 📄AboutJA = """
                    ==== Native(japanese) ====
                    iPhoneにプリインストールされているApple「ヘルスケア」アプリに体重データを(手動としては)最速で登録するためのアプリです。
                    
                    人々は体重計を用いて体重や体脂肪率は日々頻繁に計測します。多くのiPhoneユーザーは「ヘルスケア」アプリ上に体重や体脂肪率のデータを登録しています。「ヘルスケア」アプリと連携して自動的に計測データを保存してくれるスマート体重計を用いることが最高の解決策ではありますが、それらは高価であったり入手性が低かったりします。「ヘルスケア」アプリ上で手動でもデータ登録は可能ですが、残念ながら「ヘルスケア」アプリは計測データを日常的に手動で登録することを想定されていません。そのため体重測定のような日々継続的に発生するデータを手動で入力することは大いに手間が掛かりストレスフルな体験になります。そうした課題を解決するためにこのアプリは開発しました。
                    
                    このアプリでは「ヘルスケア」アプリ上の過去のデータの読み込みや閲覧、管理等は出来ません。このアプリは「ヘルスケア」アプリへのデータ登録のみを目的としています。登録したデータは「ヘルスケア」アプリ上で確認してください。
                    
                    【オプション】
                    - 体脂肪率も同時に登録可能。
                    - BMIを自動的に計算して同時に登録可能。
                    - 単位: kg, lbs, st
                    
                    【その他】
                    - このアプリ内からApple「ヘルスケア」アプリをワンタップで立ち上げ可能。
                    - 動作確認や簡易バックアップを想定した端末内での履歴機能。
                    - アプリ内でアプリ自身のソースコードを確認
                    - すべての機能を無料で利用できます。
                    - 自作アプリに関するバナー広告をアプリ内で比較的控えめに表示します。
                    """
