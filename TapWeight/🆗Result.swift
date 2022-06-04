
import SwiftUI

struct 🆗Result: View {
    @EnvironmentObject var 📱:📱Model
    
    @Environment(\.dismiss) var 🔙: DismissAction
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(📱.🚩RegisterSuccess ? .pink : .gray)
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    if 📱.🚩RegisterSuccess {
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
                        Image(systemName: 📱.🚩RegisterSuccess ? "checkmark" : "exclamationmark.triangle")
                            .font(.system(size: 128).weight(.semibold))
                            .minimumScaleFactor(0.1)
                        
                        Text(📱.🚩RegisterSuccess ? "DONE!" : "🌏Error!?")
                            .font(.system(size: 128).weight(.black))
                            .lineLimit(1)
                            .minimumScaleFactor(0.1)
                        
                        if 📱.🚩RegisterSuccess {
                            Text("Registration for \"Health\" app")
                                .bold()
                                .opacity(0.8)
                        } else {
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
                .opacity(📱.🚩Canceled ? 0.5 : 1)
                .accessibilityLabel("🌏Dismiss")
                
                
                HStack(alignment: .bottom) {
                    if 📱.🚩AdBanner && 📱.🚩RegisterSuccess {
                        🗯AdBanner(📱.🄰ppName)
                    }
                    
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
        .onAppear {
            📱.🄻aunchCount += 1
            if 📱.🄻aunchCount % 📱.🅃iming == 0 {
                📱.🚩AdBanner = true
            }
        }
        .onDisappear {
            📱.🅁eset()
        }
    }
}
