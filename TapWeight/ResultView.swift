
import SwiftUI


struct ResultView: View {
    
    @Binding var 🚩InputDone: Bool
    
    @Binding var 🚩Success: Bool
    
    var body: some View {
        ZStack {
            🚩Success ? Color.pink : Color.gray
            
            VStack {
                Button {
                    🚩InputDone = false
                } label: {
                    VStack(spacing: 16) {
                        Spacer()
                        
                        Image(systemName: 🚩Success ? "figure.wave" : "exclamationmark.triangle")
                            .font(.system(size: 128).weight(.semibold))
                        
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
                    Text("self-AD")
                        .fontWeight(.heavy)
                        .underline()
                        .kerning(1.5)
                        .offset(y: 8)
                        .foregroundStyle(.secondary)
                        .padding(.leading, 32)
                    
                    Spacer()
                    
                    💟JumpButton()
                }
                
                if true {
                    🗯AdOnList(🄰ppName: .FadeInAlarm)
                        .padding(.horizontal)
                        .background {
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .shadow(radius: 3)
                        }
                        .padding(.horizontal)
                        .padding(.bottom)
                }
            }
        }
        .ignoresSafeArea()
        .preferredColorScheme(.dark)
    }
}




struct ResultView_Previews: PreviewProvider {
    static var previews: some View {
        ResultView(🚩InputDone: .constant(true), 🚩Success: .constant(true))
    }
}
