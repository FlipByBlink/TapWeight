
import SwiftUI


struct ResultView: View {
    
    var 🄰ppName: 🗯AppList
    
    @State private var 🄿resentNote = false
    
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
                    
                    Spacer()
                    
                    💟JumpButton()
                }
            }
        }
        .ignoresSafeArea()
        .preferredColorScheme(.dark)
    }
}




struct ResultView_Previews: PreviewProvider {
    static var previews: some View {
        ResultView(🄰ppName: .FadeInAlarm,
                   🚩InputDone: .constant(true),
                   🚩Success: .constant(true))
    }
}
