
import SwiftUI

struct 💸ADView: View {
    
    var 🄰ppName: 💸AppName
    
    var body: some View {
        HStack(spacing: 12) {
            Image(🄰ppName.rawValue)
                .resizable()
                .frame(width: 60, height: 60)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                .shadow(radius: 1.5, y: 0.5)
                .padding(.vertical, 40)
            
            Link(destination: 🄰ppName.🔗URL) {
                VStack(alignment: .leading, spacing: 2) {
                    HStack {
                        Text(🄰ppName.rawValue)
                            .font(.headline)
                        
                        Image(systemName: "arrow.up.forward.app")
                            .imageScale(.small)
                    }
                    
                    Text(🄰ppName.📄About)
                        .font(.subheadline)
                        .multilineTextAlignment(.leading)
                }
                .padding(.vertical)
            }
            .accessibilityLabel(🄰ppName.rawValue)
        }
        .padding(.leading, 4)
    }
    
    
    init(_ ⓐppName: 💸AppName? = nil) {
        if let 🏷 = ⓐppName {
            🄰ppName = 🏷
        } else {
            🄰ppName = 💸AppName.allCases.randomElement()!
        }
    }
}
