
import SwiftUI


struct 🆗Result: View {
    @EnvironmentObject var 📱:📱Model
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(📱.🚩Success ? .pink : .gray)
                .ignoresSafeArea()
            
            VStack {
                Button {
                    📱.🚩InputDone = false
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
                    if 📱.🚩AdBanner && 📱.🚩Success {
                        🗯AdBanner(📱.🄰ppName)
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
            📱.🄻aunchCount += 1
            if 📱.🄻aunchCount % 📱.🅃iming == 0 {
                📱.🚩AdBanner = true
            }
        }
    }
}
