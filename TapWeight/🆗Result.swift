
import SwiftUI


struct 🆗Result: View {
    
    @EnvironmentObject var 📱:📱Model
    
    @Environment(\.dismiss) var 🔙: DismissAction
    
    
    @State private var 🚩AdBanner = false
    
    var 🄰ppName: 🗯AppList {
        switch ( 🄻aunchCount / 🅃iming ) % 3 {
            case 0: return .FlipByBlink
            case 1: return .FadeInAlarm
            default: return .Plain将棋盤
        }
    }
    
    var 🅃iming: Int = 7
    
    @AppStorage("🄻aunchCount") var 🄻aunchCount: Int = 0
    
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(📱.🚩Success ? .pink : .gray)
                .ignoresSafeArea()
            
            VStack {
                Button {
                    🔙.callAsFunction()
                } label: {
                    VStack(spacing: 12) {
                        Image(systemName: 📱.🚩Success ? "app.badge.checkmark" : "exclamationmark.triangle")
                            .font(.system(size: 128).weight(.semibold))
                            .minimumScaleFactor(0.1)
                        
                        Text(📱.🚩Success ? "OK!" : "🌏Error!?")
                            .font(.system(size: 128).weight(.black))
                            .lineLimit(1)
                            .minimumScaleFactor(0.1)
                        
                        if 📱.🚩Success == false {
                            Text("🌏Please check permission on \"Health\" app")
                                .font(.body.weight(.semibold))
                                .foregroundColor(.secondary)
                                .lineLimit(1)
                                .minimumScaleFactor(0.1)
                                .padding(.horizontal)
                        }
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .accessibilityLabel("🌏Dismiss")
                
                
                HStack(alignment: .bottom) {
                    if 🚩AdBanner && 📱.🚩Success {
                        🗯AdBanner(🄰ppName)
                    }
                    
                    Spacer()
                    
                    VStack {
                        if 📱.🚩Success == false {
                            Image(systemName: "arrow.down")
                                .imageScale(.small)
                                .font(.largeTitle)
                                .foregroundStyle(.tertiary)
                                .padding(.trailing, 24)
                                .padding(.bottom, 8)
                        }
                        
                        💟JumpButton()
                    }
                }
            }
        }
        .preferredColorScheme(.dark)
        .onAppear {
            🄻aunchCount += 1
            if 🄻aunchCount % 🅃iming == 0 {
                🚩AdBanner = true
            }
        }
    }
}
