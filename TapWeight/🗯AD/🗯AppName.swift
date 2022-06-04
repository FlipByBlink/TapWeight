
import SwiftUI

enum 🗯AppName: String {
    case FlipByBlink
    case FadeInAlarm
    case Plain将棋盤
    
    var 🔗URL: URL {
        switch self {
            case .FlipByBlink: return URL(string: "https://apps.apple.com/app/id1444571751")!
            case .FadeInAlarm: return URL(string: "https://apps.apple.com/app/id1465336070")!
            case .Plain将棋盤: return URL(string: "https://apps.apple.com/app/id1620268476")!
        }
    }
    
    var 📄About: LocalizedStringKey {
        switch self {
            case .FlipByBlink: return "🌏AboutFlipByBlink"
            case .FadeInAlarm: return "🌏AboutFadeInAlarm"
            case .Plain将棋盤: return "🌏AboutPlain将棋盤"
        }
    }
}
