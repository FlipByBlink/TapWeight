
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
                    
                        Spacer()
                    
                        VStack(alignment: .trailing, spacing: 6) {
                            Text("BodyMass: " + 📱.📝BodyMass.description + 📱.📏Unit.rawValue)
                            
                            if 📱.🚩BMI {
                                Text("BMI: " + 📱.📝BMI.description)
                            }
                            
                            if 📱.🚩BodyFat {
                                Text("BodyFat: " + (round(📱.📝BodyFat*1000)/10).description + "%")
                            }
                        }
                        .font(.body.bold())
                        .padding(24)
                    }
                    .opacity(0.75)
                }
                
                Button {
                    🔙.callAsFunction()
                } label: {
                    VStack(spacing: 12) {
                        Image(systemName: 📱.🚩RegisterError ? "exclamationmark.triangle" : "checkmark")
                            .font(.system(size: 96).weight(.semibold))
                            .minimumScaleFactor(0.1)
                        
                        Text(📱.🚩RegisterError ? "🌏Error!?" : "DONE!")
                            .font(.system(size: 96).weight(.black))
                            .lineLimit(1)
                            .minimumScaleFactor(0.1)
                            .padding(.horizontal)
                        
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
                    .padding(.bottom, 48)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .opacity(📱.🚩Canceled ? 0.33 : 1)
                .accessibilityLabel("🌏Dismiss")
                
                
                HStack(alignment: .bottom) {
                    💸AdBanner()
                    
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
