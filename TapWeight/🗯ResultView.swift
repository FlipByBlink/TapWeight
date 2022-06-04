
import SwiftUI

struct 🗯ResultView: View {
    @EnvironmentObject var 📱:📱Model
    
    let a💰🪙💸 = ""
    
    @Environment(\.dismiss) var 🔙: DismissAction
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(📱.🚩RegisterError ? .gray : .pink)
                .ignoresSafeArea()
            
            VStack {
                💸AdBanner()
                
                Button {
                    🔙.callAsFunction()
                } label: {
                    VStack(spacing: 12) {
                        Spacer()
                        
                        Image(systemName: 📱.🚩RegisterError ? "exclamationmark.triangle" : "checkmark")
                            .font(.system(size: 96).weight(.semibold))
                            .minimumScaleFactor(0.1)
                        
                        Text(📱.🚩RegisterError ? "🌏Error!?" : "DONE!")
                            .font(.system(size: 96).weight(.black))
                            .lineLimit(1)
                            .minimumScaleFactor(0.1)
                        
                        if 📱.🚩RegisterError {
                            Text("🌏Please check permission on \"Health\" app")
                                .font(.body.weight(.semibold))
                                .foregroundColor(.secondary)
                                .lineLimit(1)
                                .minimumScaleFactor(0.1)
                        } else {
                            Text("Registration for \"Health\" app")
                                .bold()
                                .opacity(0.8)
                        }
                        
                        Spacer()
                        
                        if 📱.🚩RegisterError == false {
                            HStack(spacing: 4) {
                                Text(📱.📝BodyMass.description + " " + 📱.📏Unit.rawValue)
                                
                                if 📱.🚩BMI {
                                    Text("/")
                                    
                                    Text(📱.📝BMI.description)
                                }
                                
                                if 📱.🚩BodyFat {
                                    Text("/")
                                    
                                    Text((round(📱.📝BodyFat*1000)/10).description + " %")
                                }
                            }
                            .padding()
                            .font(.subheadline.bold())
                            .opacity(0.75)
                        }
                        
                        Spacer()
                    }
                    .padding()
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .opacity(📱.🚩Canceled ? 0.33 : 1)
                .accessibilityLabel("🌏Dismiss")
                
                
                HStack(alignment: .bottom) {
                    if 📱.🚩RegisterError == false {
                        HStack {
                            Button {
                                📱.🗑Cancel()
                            } label: {
                                Image(systemName: "arrow.uturn.backward.circle")
                                    .font(.title)
                                    .imageScale(.large)
                                    .foregroundColor(.primary)
                                    .padding()
                                    .padding(.leading, 8)
                                    .padding(.bottom, 8)
                            }
                            .disabled(📱.🚩Canceled)
                            .opacity(📱.🚩Canceled ? 0.5 : 1)
                            .accessibilityLabel("Cancel")
                            
                            
                            if 📱.🚩Canceled {
                                VStack {
                                    Text("Canceled")
                                        .fontWeight(.semibold)
                                    
                                    if 📱.🚩CancelError {
                                        Text("(perhaps error)")
                                    }
                                }
                            }
                        }
                    }
                    
                    Spacer()
                    
                    VStack {
                        if 📱.🚩RegisterError {
                            Image(systemName: "arrow.down")
                                .imageScale(.small)
                                .font(.largeTitle)
                                .foregroundStyle(.secondary)
                                .padding(.trailing, 24)
                                .padding(.bottom, 8)
                        }
                        
                        💟JumpButton()
                            .foregroundStyle(.primary)
                    }
                }
                .opacity(0.75)
            }
        }
        .preferredColorScheme(.dark)
        .onDisappear {
            📱.🅁eset()
        }
    }
}
