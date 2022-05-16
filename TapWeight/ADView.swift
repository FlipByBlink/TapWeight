
import SwiftUI
import StoreKit


struct 🗯AdView: View {
    
    var 🅃iming: Int = 1
    
    @State private var 🄿resentAdBanner = false
    
    @State private var 🄿resentNote = false
    
    @AppStorage("🄻aunchCount") var 🄻aunchCount: Int = 0
    
    var 🚩AdBanner: Bool {
        ( 🄻aunchCount % 🅃iming ) == 0
    }
    
    var 🆔: String {
        //FlipByBlink appIdentifier: 1444571751
        //FadeInAlarm appIdentifier: 1465336070
        //Plain将棋盤 appIdentifier: 1620268476
        switch ( 🄻aunchCount / 🅃iming ) % 3 {
        case 0: return "1444571751"
        case 1: return "1465336070"
        default: return "1620268476"
        }
    }
    
    
    var body: some View {
        VStack {
            Spacer()
            
            if 🄿resentAdBanner {
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
                .transition(.move(edge: .bottom))
                .padding(6)
                .padding(.bottom, 100)
            }
        }
        .animation(.easeIn, value: 🄿resentAdBanner)
        .appStoreOverlay(isPresented: $🄿resentAdBanner) {
            SKOverlay.AppConfiguration(appIdentifier: 🆔, position: .bottom)
        }
        .onAppear {
            🄻aunchCount += 1
            if 🄻aunchCount % 🅃iming == 0 {
                🄿resentAdBanner = true
            }
        }
    }
}


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
        Link(destination: 🄰ppName.🔗) {
            HStack {
                Image(🄰ppName.rawValue)
                    .resizable()
                    .frame(width: 60, height: 60)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .shadow(radius: 1.5, y: 0.5)
                    .padding(8)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(🄰ppName.rawValue)
                        .font(.headline)
                    
                    Text(🄰ppName.📄)
                        .font(.subheadline)
                }
                
                Spacer()
                
                Image(systemName: "arrow.up.forward.app")
            }
            .padding(.vertical)
        }
        .accessibilityLabel(🄰ppName.rawValue)
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
