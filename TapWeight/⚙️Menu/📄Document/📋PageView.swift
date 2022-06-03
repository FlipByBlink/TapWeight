
import SwiftUI

struct 📋PageView: View {
    var 🅃ext: String
    var 🅃itle: String
    
    var body: some View {
        Text(🅃ext)
            .navigationBarTitle(🅃itle)
            .navigationBarTitleDisplayMode(.inline)
            .font(.caption.monospaced())
            .padding()
            .textSelection(.enabled)
    }
    
    init(_ ⓣext: String, _ ⓣitle: String) {
        🅃ext = ⓣext
        🅃itle = ⓣitle
    }
}
