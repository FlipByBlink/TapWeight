
import SwiftUI


enum 🗯AppList: String {
    case FlipByBlink
    case FadeInAlarm
    case Plain将棋盤
    
    var 🔗: URL {
        switch self {
        case .FlipByBlink: return URL(string: "https://apps.apple.com/app/id1444571751")!
        case .FadeInAlarm: return URL(string: "https://apps.apple.com/app/id1465336070")!
        case .Plain将棋盤: return URL(string: "https://apps.apple.com/app/id1620268476")!
        }
    }
    
    var 📄: LocalizedStringKey {
        switch self {
        case .FlipByBlink: return "🌏AboutFlipByBlink"
        case .FadeInAlarm: return "🌏AboutFadeInAlarm"
        case .Plain将棋盤: return "🌏AboutPlain将棋盤"
        }
    }
}


struct 🗯AdOnList: View {
    var 🄰ppName: 🗯AppList
    
    var body: some View {
        HStack {
            Image(🄰ppName.rawValue)
                .resizable()
                .frame(width: 60, height: 60)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                .shadow(radius: 1.5, y: 0.5)
                .padding(8)
            
            Link(destination: 🄰ppName.🔗) {
                HStack {
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(🄰ppName.rawValue)
                            .font(.headline)
                        
                        Text(🄰ppName.📄)
                            .font(.subheadline)
                            .multilineTextAlignment(.leading)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "arrow.up.forward.app")
                }
                .padding(.vertical)
            }
            .accessibilityLabel(🄰ppName.rawValue)
        }
        
    }
}


struct 🗯AdSection: View {
    var body: some View {
        Section {
            🗯AdOnList(🄰ppName: .FadeInAlarm)
            🗯AdOnList(🄰ppName: .FlipByBlink)
            🗯AdOnList(🄰ppName: .Plain将棋盤)
        } header: {
            Text("🌏self-AD")
        }
    }
}
