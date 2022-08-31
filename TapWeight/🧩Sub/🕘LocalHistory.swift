
import SwiftUI

struct 🕘LocalHistoryView: View {
    @EnvironmentObject var 📱: 📱AppModel
        
    var body: some View {
        List {
            Section {
                Text("\"Local history\" is for the porpose of \"operation check\" / \"temporary backup\"")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .listRowBackground(Color.clear)
            }
            
            ForEach(📱.🕘LocalHistory.ⓛogs.reversed()) { ⓛog in
                🄻ogSection(ⓛog)
            }
            
            if 📱.🕘LocalHistory.ⓛogs.isEmpty {
                Text("No log")
                    .font(.headline)
                    .foregroundStyle(.tertiary)
            }
            
            🕘LocalHistoryBeforeVer_1_2_Link()
        }
        .navigationTitle("Local history")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    withAnimation {
                        📱.🕘LocalHistory.ⓛogs.removeAll()
                        UINotificationFeedbackGenerator().notificationOccurred(.warning)
                    }
                } label: {
                    Image(systemName: "trash")
                        .tint(.red)
                }
            }
        }
    }
    
    struct 🄻ogSection: View {
        var ⓛog: 🕘Log
        var body: some View {
            Section {
                if let ⓔntry = ⓛog.entry {
                    if ⓛog.date.timeIntervalSince(ⓔntry.date) > 300 {
                        Label(ⓔntry.date.formatted(date: .abbreviated, time: .shortened), systemImage: "clock")
                            .foregroundColor(.primary)
                    }
                    
                    Text("Body Mass")
                        .strikethrough(ⓔntry.cancellation)
                        .badge(ⓔntry.massSample.value.description + " " + ⓔntry.massSample.unit.rawValue)
                    
                    if let ⓥalue = ⓔntry.bmiValue {
                        Text("Body Mass Index")
                            .strikethrough(ⓔntry.cancellation)
                            .badge(ⓥalue.description)
                    }
                    
                    if let ⓥalue = ⓔntry.bodyFatValue {
                        Text("Body Fat Percentage")
                            .strikethrough(ⓔntry.cancellation)
                            .badge((round(ⓥalue*1000)/10).description + " %")
                    }
                } else if let ⓒomment = ⓛog.comment {
                    Text(ⓒomment)
                } else {
                    EmptyView()
                }
            } header: {
                Text(ⓛog.date.formatted(date: .abbreviated, time: .shortened))
            } footer: {
                if ⓛog.entry?.cancellation == true {
                    Text("Canceled")
                }
            }
        }
        init(_ ⓛog: 🕘Log) {
            self.ⓛog = ⓛog
        }
    }
}


struct 🕘LocalHistoryModel {
    var ⓛogs: [Log] = [] {
        didSet {
            do {
                UserDefaults.standard.set(try JSONEncoder().encode(ⓛogs), forKey: "LocalHistory")
            } catch {
                print("🚨Error: ", error)
            }
        }
    }
    
    init() {
        if let ⓤd = UserDefaults.standard.data(forKey: "LocalHistory") {
            do {
                ⓛogs = try JSONDecoder().decode([Log].self, from: ⓤd)
            } catch {
                print("🚨Error: ", error)
            }
        }
    }
    
    mutating func addLog(_ ⓔntry: 🕘Entry) {
        ⓛogs.append(Log(entry: ⓔntry))
    }
    
    mutating func addLog(_ ⓒomment: String) {
        ⓛogs.append(Log(comment: ⓒomment))
        print(ⓒomment)
    }
    
    mutating func modifyCancellation() {
        var ⓛog = ⓛogs.popLast()!
        ⓛog.entry?.cancellation = true
        ⓛogs.append(ⓛog)
    }
    
    struct Log: Codable, Identifiable {
        var date: Date = .now
        var entry: Entry? = nil
        var comment: String? = nil
        var id: Date { date }
        
        struct Entry: Codable {
            var date: Date
            var massSample: MassSample
            var bmiValue: Double?
            var bodyFatValue: Double?
            var cancellation: Bool = false
            
            struct MassSample: Codable {
                var unit: 📏BodyMassUnit
                var value: Double
            }
        }
    }
}

typealias 🕘Log = 🕘LocalHistoryModel.Log
typealias 🕘Entry = 🕘LocalHistoryModel.Log.Entry









struct 🕘LocalHistoryBeforeVer_1_2_Link: View {
    @AppStorage("History") var 🕘History: String = ""
    
    var body: some View {
        if 🕘History != "" {
            NavigationLink("Old data before ver 1.2") {
                🕘MainView()
            }
        }
    }
    
    struct 🕘MainView: View {
        @AppStorage("History") var 🕘History: String = ""
        
        var body: some View {
            VStack (spacing: 0) {
                if 🕘History == "" {
                    Spacer()
                    
                    Image(systemName: "text.append")
                        .foregroundStyle(.tertiary)
                        .font(.system(size: 64))
                        .navigationTitle("History")
                        .navigationBarTitleDisplayMode(.inline)
                    
                    Spacer()
                } else {
                    ScrollView {
                        ScrollView(.horizontal, showsIndicators: false) {
                            Text(🕘History)
                                .padding()
                        }
                    }
                    .navigationBarTitle("History")
                    .navigationBarTitleDisplayMode(.inline)
                    .font(.caption.monospaced())
                    .textSelection(.enabled)
                }
                
                Color.secondary
                    .frame(height: 0.4)
                
                Text("\"Local history\" is for the porpose of \"operation check\" / \"temporary backup\"")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .padding(24)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        🕘History = ""
                    } label: {
                        Image(systemName: "trash")
                            .tint(.red)
                    }
                }
            }
        }
    }
}
