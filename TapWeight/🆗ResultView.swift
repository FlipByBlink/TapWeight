
import SwiftUI

struct 🆗ResultView: View { //🆗を変更
    @EnvironmentObject var 📱:📱Model
    
    @Environment(\.dismiss) var 🔙: DismissAction
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(📱.🚩RegisterError ? .gray : .pink)
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    if 📱.🚩RegisterError == false {
                        Button {
                            📱.🗑Cancel()
                        } label: {
                            Image(systemName: "arrow.uturn.backward.circle")
                                .font(.title)
                                .imageScale(.large)
                                .foregroundColor(.primary)
                                .padding()
                        }
                        .disabled(📱.🚩Canceled)
                        .opacity(📱.🚩Canceled ? 0.5 : 1)
                        .accessibilityLabel("Cancel")
                        
                        if 📱.🚩Canceled {
                            Text("Canceled")
                                .fontWeight(.semibold)
                            
                            if 📱.🚩CancelError {
                                Text("(perhaps error)")
                            }
                        }
                    }
                    
                    Spacer()
                }
                
                
                Button {
                    🔙.callAsFunction()
                } label: {
                    VStack(spacing: 12) {
                        Image(systemName: 📱.🚩RegisterError ? "exclamationmark.triangle" : "checkmark")
                            .font(.system(size: 128).weight(.semibold))
                            .minimumScaleFactor(0.1)
                        
                        Text(📱.🚩RegisterError ? "🌏Error!?" : "DONE!")
                            .font(.system(size: 128).weight(.black))
                            .lineLimit(1)
                            .minimumScaleFactor(0.1)
                        
                        if 📱.🚩RegisterError {
                            Text("🌏Please check permission on \"Health\" app")
                                .font(.body.weight(.semibold))
                                .foregroundColor(.secondary)
                                .lineLimit(1)
                                .minimumScaleFactor(0.1)
                                .padding(.horizontal)
                        } else {
                            Text("Registration for \"Health\" app")
                                .bold()
                                .opacity(0.8)
                        }
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .opacity(📱.🚩Canceled ? 0.5 : 1)
                .accessibilityLabel("🌏Dismiss")
                
                
                HStack(alignment: .bottom) {
                    🗯AdBanner()
                    
                    Spacer()
                    
                    VStack {
                        if 📱.🚩RegisterError {
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
        .onDisappear {
            📱.🅁eset()
        }
    }
}
