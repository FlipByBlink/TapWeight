
import SwiftUI

struct 💸ADBanner: View {
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
                        Text("self-AD")
                            .kerning(0.5)
                            .underline()
                            .foregroundColor(.white)
                            .font(.body.weight(.black))
                            .lineLimit(1)
                            .minimumScaleFactor(0.1)
                    }
                    .alert("About self-AD", isPresented: $🄿resentNote) {
                        Button("OK") {
                            print("Pressed OK button.")
                        }
                    } message: {
                        💸TextAboutAD()
                    }
                    .opacity(0.75)
                    .padding(.leading, 32)
                    .offset(y: 8)
                    
                    
                    💸ADView(🄰ppName)
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




//struct 💸ADBanner: View {
//    @EnvironmentObject var 🏬: 🏬Store
//    
//    @State private var 🚩ShowBanner = false
//    
//    @AppStorage("🄻aunchCount") var 🄻aunchCount: Int = 0
//    
//    let 🅃iming: Int = 1 //TODO: Edit
//    
//    var body: some View {
//        Group {
//            if 🏬.🚩Purchased {
//                EmptyView()
//            } else {
//                if 🚩ShowBanner {
//                    💸ADView()
//                        .padding(.horizontal)
//                        .overlay(alignment: .topLeading) {
//                            Button {
//                                🚩ShowBanner = false
//                            } label: {
//                                Image(systemName: "xmark.circle")
//                                    .padding(8)
//                            }
//                            .foregroundStyle(.tertiary)
//                        }
//                        .overlay(alignment: .bottomLeading) {
//                            Text("AD")
//                                .scaleEffect(x: 1.2)
//                                .font(.subheadline.weight(.black))
//                                .padding(.leading)
//                                .padding(.bottom, 5)
//                                .foregroundStyle(.quaternary)
//                        }
//                        .background {
//                            RoundedRectangle(cornerRadius: 16, style: .continuous)
//                                .foregroundStyle(.background)
//                                .shadow(radius: 3)
//                        }
//                        .padding()
//                        .transition(.move(edge: .bottom))
//                }
//            }
//        }
//        .animation(.easeOut.speed(1.5), value: 🚩ShowBanner)
//        .animation(.easeOut.speed(1.5), value: 🏬.🚩Purchased)
//        .task {
//            🄻aunchCount += 1
//            
//            Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { _ in
//                if 🄻aunchCount % 🅃iming == 0 {
//                    🚩ShowBanner = true
//                }
//            }
//        }
//    }
//}
