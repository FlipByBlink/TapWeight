
import SwiftUI

struct 💸AdBanner: View {
    @EnvironmentObject var 📱:📱Model
    
    @State private var 🚩AdBanner = false
    
    @AppStorage("🄻aunchCount") var 🄻aunchCount: Int = 0
    
    @State private var 🄿resentNote = false
    
    var 🄰ppName: 💸AppName {
        switch ( 🄻aunchCount / 🅃iming ) % 4 {
            case 0: return .FlipByBlink
            case 1: return .FadeInAlarm
            case 2: return .Plain将棋盤
            default: return .TapTemperature
        }
    }
    
    var 🅃iming: Int = 7
    
    var body: some View {
        Group {
            if 🚩AdBanner && (📱.🚨RegisterError == false) {
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
                    .opacity(0.75)
                    .padding(.leading, 32)
                    .offset(y: 8)
                    
                    
                    💸AdView(🄰ppName)
                        .padding(.horizontal)
                        .background {
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .shadow(radius: 3)
                        }
                        .padding(.horizontal)
                        .padding(.bottom)
                }
            } else {
                Spacer()
            }
        }
        .onAppear {
            🄻aunchCount += 1
            if 🄻aunchCount % 🅃iming == 0 {
                🚩AdBanner = true
            }
        }
    }
}
