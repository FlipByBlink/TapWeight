
import SwiftUI

struct 📋TextView: View {
    var 🅃ext: String
    var 🅃itle: String
    
    var 🚩HorizonScroll: Bool
    
    var body: some View {
        Group {
            if 🚩HorizonScroll {
                ScrollView {
                    ScrollView(.horizontal, showsIndicators: false) {
                        Text(🅃ext)
                            .padding()
                    }
                }
            } else {
                ScrollView {
                    Text(🅃ext)
                        .padding()
                }
            }
        }
        .navigationBarTitle(🅃itle)
        .navigationBarTitleDisplayMode(.inline)
        .font(.caption.monospaced())
        .textSelection(.enabled)
    }
    
    init(_ ⓣext: String, _ ⓣitle: String, ⓗorizonScroll: Bool = false) {
        🅃ext = ⓣext
        🅃itle = ⓣitle
        🚩HorizonScroll = ⓗorizonScroll
    }
}
