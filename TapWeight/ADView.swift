
import SwiftUI
import StoreKit


struct ADView: View {
    
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


struct ADViewOnList: View {
    var body: some View {
        Section {
            Link(destination: URL(string: "https://apps.apple.com/app/id1465336070")!) {
                HStack {
                    Image("FadeInAlarm")
                        .resizable()
                        .frame(width: 64, height: 64)
                        .padding(8)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("FadeInAlarm")
                            .font(.headline)
                        
                        Text("時間をかけて少しずつ音量が大きくなるアラームアプリ。")
                            .font(.subheadline)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "arrow.up.forward.app")
                }
            }
        } header: {
            Text("🌏self-AD")
        }
    }
}
