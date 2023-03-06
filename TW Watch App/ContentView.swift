import SwiftUI

struct ContentView: View {
    @EnvironmentObject var 📱: 📱AppModel
    var body: some View {
        NavigationStack {
            List {
                Text(📱.ⓜassInputDescription)
                Text(📱.ⓑmiInputValue?.description ?? "?")
                Text(📱.ⓑodyFatInputDescription)
            }
            .navigationTitle("Body Mass")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static let ⓜodel = 📱AppModel()
    static var previews: some View {
        ContentView()
            .environmentObject(self.ⓜodel)
    }
}
