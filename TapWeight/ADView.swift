
import SwiftUI
import StoreKit


struct ADView: View {
    @State private var 🄿resentAdBanner = false
    
    @State private var 🄿resentNote = false
    
    @AppStorage("🄻aunchCount") var 🄻aunchCount: Int = 0
    
    var 🚩AdBanner: Bool {
        true
//        ( 🄻aunchCount % 6 ) == 0
    }
    
    var 🆔: String {
        //FlipByBlink appIdentifier: 1444571751
        //FadeInAlarm appIdentifier: 1465336070
        //Plain将棋盤 appIdentifier: 1620268476
        
//        switch ( 🄻aunchCount / 6 ) % 3 {
        switch ( 🄻aunchCount / 1 ) % 3 {
        case 0: return "1444571751"
        case 1: return "1465336070"
        default: return "1620268476"
        }
    }
    
    
    var body: some View {
        VStack {
            Spacer()
            
            if 🄿resentAdBanner {
                HStack {
                    Button {
                        🄿resentNote = true
                    } label: {
                        Text("🌏セルフ広告")
                            .kerning(0.5)
                            .underline()
                            .foregroundStyle(.tertiary)
                            .grayscale(1)
                            .font(.body.weight(.heavy))
                            .lineLimit(1)
                            .minimumScaleFactor(0.1)
                    }
                    .alert("🌏セルフ広告について", isPresented: $🄿resentNote) {
                        Button("🌏了解しました") {
                            print("Pressed OK button.")
                        }
                    } message: {
                        Text("🌏広告説明文")
                    }
                    
//                    Button {
//                        🄿resentAdBanner = false
//                    } label: {
//                        Image(systemName: "xmark.circle.fill")
//                            .foregroundStyle(.tertiary)
//                            .font(.body.weight(.heavy))
//                            .grayscale(1)
//                            .minimumScaleFactor(0.1)
//                    }
                }
                .transition(.move(edge: .bottom))
                .padding(6)
                .background {
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundColor(Color(.systemBackground))
                        .opacity(0.7)
                }
                .padding(.bottom, 100)
            }
        }
        .animation(.easeIn, value: 🄿resentAdBanner)
        .appStoreOverlay(isPresented: $🄿resentAdBanner) {
            SKOverlay.AppConfiguration(appIdentifier: 🆔, position: .bottom)
        }
        .onAppear {
            🄻aunchCount += 1
//            if 🄻aunchCount % 6 == 0 {
                🄿resentAdBanner = true
//            }
        }
    }
}
