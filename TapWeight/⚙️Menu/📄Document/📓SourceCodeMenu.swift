
import SwiftUI

struct 📓SourceCodeMenu: View {
    @Environment(\.dismiss) var 🔙: DismissAction
    
    var 📁URL: URL {
        Bundle.main.bundleURL.appendingPathComponent("📁")
    }
    
    var 🏷Name: [String] {
        try! FileManager.default.contentsOfDirectory(atPath: 📁URL.path)
    }
    
    var body: some View {
        List {
            Section {
                ForEach(🏷Name, id: \.self) { 🏷 in
                    NavigationLink(🏷) {
                        let 📍 = 📁URL.appendingPathComponent(🏷)
                        ScrollView {
                            ScrollView(.horizontal, showsIndicators: false) {
                                📋TextView(try! String(contentsOf: 📍), 🏷)
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


let 🄱undleMainInfoDictionary = Bundle.main.infoDictionary!.description
struct 📑BundleMainInfoDictionary: View {
    var body: some View {
        Section {
            NavigationLink("Bundle.main.infoDictionary") {
                ScrollView {
                    📋TextView(🄱undleMainInfoDictionary, "Bundle.main.infoDictionary")
                }
            }
        }
    }
}
