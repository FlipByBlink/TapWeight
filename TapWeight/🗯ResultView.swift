
import SwiftUI

struct 🗯ResultView: View {
    @EnvironmentObject var 📱:📱Model
    
    @Environment(\.dismiss) var 🔙: DismissAction
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(📱.🚨RegisterError ? .gray : .pink)
                .ignoresSafeArea()
            
            VStack {
                💸AdBanner()
                
                Button {
                    🔙.callAsFunction()
                } label: {
                    VStack(spacing: 16) {
                        Spacer()
                        
                        Image(systemName: 📱.🚨RegisterError ? "exclamationmark.triangle" : "checkmark")
                            .font(.system(size: 96).weight(.semibold))
                            .minimumScaleFactor(0.1)
                        
                        Text(📱.🚨RegisterError ? "ERROR!?" : "DONE!")
                            .font(.system(size: 96).weight(.black))
                            .lineLimit(1)
                            .minimumScaleFactor(0.1)
                        
                        if 📱.🚨RegisterError {
                            Text("Please check permission on \"Health\" app")
                                .font(.title3.weight(.semibold))
                                .lineLimit(1)
                                .minimumScaleFactor(0.1)
                        } else {
                            Text("Registration for \"Health\" app")
                                .font(.title3.weight(.semibold))
                                .lineLimit(1)
                                .minimumScaleFactor(0.1)
                        }
                        
                        Spacer()
                        
                        if 📱.🚨RegisterError == false {
                            let 🅂ummary: String = {
                                var 🪧 = ""
                                🪧 += 📱.📝BodyMass.description + " " + 📱.📏Unit.rawValue
                                if 📱.🚩AbleBMI { 🪧 += " / " + 📱.📝BMI.description }
                                if 📱.🚩AbleBodyFat {
                                    🪧 += " / " + (round(📱.📝BodyFat*1000)/10).description + " %"
                                }
                                return 🪧
                            }()
                            
                            Text(🅂ummary)
                                .font(.body.bold())
                                .lineLimit(1)
                                .minimumScaleFactor(0.1)
                                .opacity(0.75)
                        }
                        
                        Spacer()
                        
                        Color.clear
                            .frame(height: 32)
                    }
                    .padding()
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .opacity(📱.🚩Canceled ? 0.33 : 1)
                .accessibilityLabel("Dismiss")
            }
            .overlay(alignment: .bottomLeading) {
                if 📱.🚨RegisterError == false {
                    HStack {
                        Button {
                            📱.🗑Cancel()
                        } label: {
                            Image(systemName: "arrow.uturn.backward.circle")
                                .font(.largeTitle)
                                .imageScale(.large)
                                .foregroundColor(.primary)
                                .padding(24)
                        }
                        .disabled(📱.🚩Canceled)
                        .opacity(📱.🚩Canceled ? 0.5 : 1)
                        .accessibilityLabel("Cancel")
                        
                        
                        if 📱.🚩Canceled {
                            VStack {
                                Text("Canceled")
                                    .fontWeight(.semibold)
                                
                                if 📱.🚨CancelError {
                                    Text("(perhaps error)")
                                }
                            }
                            .offset(x: -24)
                        }
                    }
                    .opacity(0.75)
                }
            }
            .overlay(alignment: .bottomTrailing) {
                VStack {
                    if 📱.🚨RegisterError {
                        Image(systemName: "arrow.down")
                            .imageScale(.small)
                            .font(.largeTitle)
                            .foregroundStyle(.secondary)
                            .offset(y: 16)
                    }
                    
                    💟JumpButton()
                        .foregroundStyle(.primary)
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
