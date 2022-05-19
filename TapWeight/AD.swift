
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


struct 🗯AdView: View {
    var 🄰ppName: 🗯AppList = .FadeInAlarm
    
    var body: some View {
        HStack {
            Image(🄰ppName.rawValue)
                .resizable()
                .frame(width: 60, height: 60)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                .shadow(radius: 1.5, y: 0.5)
            
            Link(destination: 🄰ppName.🔗) {
                VStack(alignment: .leading, spacing: 2) {
                    HStack {
                        Text(🄰ppName.rawValue)
                            .font(.headline)
                        
                        Image(systemName: "arrow.up.forward.app")
                            .imageScale(.small)
                    }
                    
                    Text(🄰ppName.📄)
                        .font(.subheadline)
                        .multilineTextAlignment(.leading)
                }
                .padding(.vertical)
            }
            .accessibilityLabel(🄰ppName.rawValue)
        }
        .padding(.horizontal)
    }
    
    init(_ 🄰ppName: 🗯AppList) {
        self.🄰ppName = 🄰ppName
    }
}


struct 🗯AdSection: View {
    var body: some View {
        Section {
            🗯AdView(.FlipByBlink)
            🗯AdView(.FadeInAlarm)
            🗯AdView(.Plain将棋盤)
        } header: {
            Text("🌏self-AD")
        }
    }
}


struct 🗯AdBanner: View {
    var 🄰ppName: 🗯AppList
    
    @State private var 🄿resentNote = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Button {
                🄿resentNote = true
            } label: {
                Text("🌏self-AD")
                    .kerning(0.5)
                    .underline()
                    .foregroundColor(.white)
                    .font(.body.weight(.black))
                    .lineLimit(1)
                    .minimumScaleFactor(0.1)
            }
            .alert("🌏About self-AD", isPresented: $🄿resentNote) {
                Button("🌏OK") {
                    print("Pressed OK button.")
                }
            } message: {
                Text("🌏TextAboutAD")
            }
            .opacity(0.5)
            .padding(.leading, 32)
            .offset(y: 8)
            
            
            🗯AdView(🄰ppName)
                .background {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .shadow(radius: 3)
                }
                .padding(.horizontal)
                .padding(.bottom)
        }
    }
    
    init(_ 🄰ppName: 🗯AppList) {
        self.🄰ppName = 🄰ppName
    }
}
