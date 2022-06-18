
import SwiftUI

struct 📓SourceCodeMenu: View {
    var body: some View {
        List {
            📰CodeSection("📁0")
            
            📰CodeSection("📁1")
            
            📰CodeSection("📁2")
            
            📰CodeSection("📁AD")
            
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
                        Label("Web Repository", systemImage: "link")
                        
                        Spacer()
                        
                        Image(systemName: "arrow.up.forward.app")
                    }
                }
            } footer: {
                Text(Repository🔗)
            }
            
            
            let Mirror🔗 = "https://gitlab.com/FlipByBlink/FlipByBlink_ver3_Mirror"
            Section {
                Link(destination: URL(string: Mirror🔗)!) {
                    HStack {
                        Label("Web Repository (Mirror)", systemImage: "link")
                        
                        Spacer()
                        
                        Image(systemName: "arrow.up.forward.app")
                    }
                }
            } footer: {
                Text(Mirror🔗)
            }
        }
        .navigationTitle("Source code")
    }
}


struct 📰CodeSection: View {
    var 🄳irectoryPath: String
    
    var 📁URL: URL {
        Bundle.main.bundleURL.appendingPathComponent(🄳irectoryPath)
    }
    
    var 🏷Name: [String] {
        try! FileManager.default.contentsOfDirectory(atPath: 📁URL.path)
    }
    
    var body: some View {
        Section {
            ForEach(🏷Name, id: \.self) { 🏷 in
                NavigationLink(🏷) {
                    let 📍 = 📁URL.appendingPathComponent(🏷)
                    
                    📋TextView(try! String(contentsOf: 📍), 🏷, ⓗorizonScroll: true)
                }
            }
        }
    }
    
    init(_ ⓓirectoryPath: String) {
        🄳irectoryPath = ⓓirectoryPath
    }
}


let 🄱undleMainInfoDictionary = Bundle.main.infoDictionary!.description
struct 📑BundleMainInfoDictionary: View {
    var body: some View {
        Section {
            NavigationLink("Bundle.main.infoDictionary") {
                📋TextView(🄱undleMainInfoDictionary, "Bundle.main.infoDictionary")
            }
        }
    }
}
