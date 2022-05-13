
import SwiftUI
import StoreKit


struct ADView: View {
    
    var ⓣiming: Int
    
    var 🎨: Color
    
    @State private var 🄿resentAdBanner = false
    
    @State private var 🄿resentNote = false
    
    @AppStorage("🄻aunchCount") var 🄻aunchCount: Int = 0
    
    var 🚩AdBanner: Bool {
        ( 🄻aunchCount % ⓣiming ) == 0
    }
    
    var 🆔: String {
        //FlipByBlink appIdentifier: 1444571751
        //FadeInAlarm appIdentifier: 1465336070
        //Plain将棋盤 appIdentifier: 1620268476
        switch ( 🄻aunchCount / ⓣiming ) % 3 {
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
                        Text("🌏self-AD")
                            .kerning(0.5)
                            .underline()
                            .foregroundColor(🎨)
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
                    
                    Button {
                        🄿resentAdBanner = false
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(🎨)
                            .font(.body.bold())
                            .minimumScaleFactor(0.1)
                    }
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
            if 🄻aunchCount % ⓣiming == 0 {
                🄿resentAdBanner = true
            }
        }
    }
}


struct ADViewOnHome: View {
    var body: some View {
        ADView(ⓣiming: 1, 🎨: .secondary)
    }
}


struct ADViewOnResult: View {
    var body: some View {
        ADView(ⓣiming: 1, 🎨: .white)
    }
}
