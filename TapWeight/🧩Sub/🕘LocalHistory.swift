
import SwiftUI

struct 🕘LocalHistoryView: View {
    @ObservedObject var 💽: 💽LocalHistoryModel
        
    var body: some View {
        List {
            Section {
                Text("\"Local history\" is for the porpose of \"operation check\" / \"temporary backup\"")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .listRowBackground(Color.clear)
            }
            
            ForEach(💽.ⓛogs.reversed()) { ⓛog in
                Section {
                    🄻ogRows(ⓛog)
                } header: {
                    Text(ⓛog.date.formatted())
                } footer: {
                    if ⓛog.canceled {
                        Text("Canceled")
                    }
                }
            }
            
            if 💽.ⓛogs.isEmpty {
                Text("No log")
                    .font(.headline)
                    .foregroundStyle(.tertiary)
            }
            
            🕘LocalHistoryBeforeVer_1_2_Link()
        }
        .navigationTitle("Local History")
        .toolbar { //TODO: WIP
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    withAnimation {
                        💽.ⓛogs.removeAll()
                    }
                } label: {
                    Image(systemName: "trash")
                        .tint(.red)
                }
            }
        }
    }
    
    struct 🄻ogRows: View {
        var ⓛog: 💽Log
        
        var body: some View {
            if let entry = ⓛog.entry {
                if ⓛog.date.timeIntervalSince(entry.date) > 300 {
                    Label(entry.date.formatted(), systemImage: "clock")
                        .foregroundColor(.primary)
                }
                
                ForEach(entry.samples) { sample in
                    Text(sample.type)
                        .strikethrough(entry.cancellation)
                        .badge(sample.value)
                }
            }
            
            if let comment = ⓛog.comment {
                Text(comment)
            }
        }
        
        init(_ ⓛog: 💽Log) {
            self.ⓛog = ⓛog
        }
    }
    
    init(_ 💽: 💽LocalHistoryModel) {
        self.💽 = 💽
    }
}


class 💽LocalHistoryModel: ObservableObject {
    @Published var ⓛogs: [🄻og] = [] {
        didSet {
            guard let DATA = try? JSONEncoder().encode(ⓛogs) else { return }
            UserDefaults.standard.set(DATA, forKey: "💽LocalHistoryModel")
        }
    }
    
    init() {
        if let ud = UserDefaults.standard.data(forKey: "💽LocalHistoryModel") {
            if let data = try? JSONDecoder().decode([🄻og].self, from: ud) {
                ⓛogs = data
            }
        }
    }
    
    struct 🄻og: Codable, Identifiable {
        var date: Date = .now
        var entry: 🄴ntry? = nil
        var comment: String? = nil
        var id: Date { date }
        
        struct 🄴ntry: Codable {
            var date: Date
            var samples: [🅂ample] = []
            var cancellation: Bool = false
            
            struct 🅂ample: Codable, Identifiable {
                var type: String
                var value: String
                var id: String { type }
            }
            
            mutating func addSample(_ type: String, _ value: String) {
                samples.append(🅂ample(type: type, value: value))
            }
        }
        
        var canceled: Bool { entry?.cancellation == true }
    }
    
    func addLog(_ entry: 💽Entry) {
        ⓛogs.append(🄻og(entry: entry))
    }
    
    func addLog(_ comment: String) {
        ⓛogs.append(🄻og(comment: comment))
    }
    
    func modifyCancellation() {
        var ⓛog = ⓛogs.popLast()!
        ⓛog.entry?.cancellation = true
        ⓛogs.append(ⓛog)
    }
}

typealias 💽Log = 💽LocalHistoryModel.🄻og
typealias 💽Entry = 💽LocalHistoryModel.🄻og.🄴ntry





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
