
import SwiftUI


struct ResultView: View {
    
    @Binding var 🚩Success: Bool
    
    @Environment(\.dismiss) var 🔙: DismissAction
    
    
    @State private var 🄿resentAdBanner = false
    
    var 🄰ppName: 🗯AppList {
        switch ( 🄻aunchCount / 🅃iming ) % 3 {
            case 0: return .FlipByBlink
            case 1: return .FadeInAlarm
            default: return .Plain将棋盤
        }
    }
    
    @State private var 🄿resentNote = false
    
    var 🅃iming: Int = 7
    
    @AppStorage("🄻aunchCount") var 🄻aunchCount: Int = 0
    
    
    var body: some View {
        ZStack {
            🚩Success ? Color.pink : Color.gray
            
            VStack {
                Button {
                    🔙.callAsFunction()
                } label: {
                    VStack(spacing: 16) {
                        Spacer()
                        
                        Image(systemName: 🚩Success ? "figure.wave" : "exclamationmark.triangle")
                            .font(.system(size: 128).weight(.semibold))
                            .minimumScaleFactor(0.1)
                        
                        Text(🚩Success ? "OK!" : "🌏Error!?")
                            .font(.system(size: 128).weight(.black))
                            .lineLimit(1)
                            .minimumScaleFactor(0.1)
                        
                        if 🚩Success == false {
                            Text("Please check permission on \"Health\" app")
                                .font(.body.weight(.semibold))
                                .foregroundColor(.secondary)
                                .lineLimit(1)
                                .minimumScaleFactor(0.1)
                                .padding(.horizontal)
                        }
                        
                        Spacer()
                    }
                    .foregroundColor(.white)
                }
                .accessibilityLabel("🌏Dismiss")
                
                
                HStack(alignment: .bottom) {
                    if 🄿resentAdBanner {
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
                            .background {
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .shadow(radius: 3)
                            }
                            .padding(.horizontal)
                            .padding(.bottom)
                        }
                    }
                    
                    Spacer()
                    
                    💟JumpButton()
                }
            }
        }
        .ignoresSafeArea()
        .preferredColorScheme(.dark)
        .onAppear {
            🄻aunchCount += 1
            if 🄻aunchCount % 🅃iming == 0 {
                🄿resentAdBanner = true
            }
        }
    }
}
