
import SwiftUI
import HealthKit

struct ContentView: View {
    @EnvironmentObject var 📱:📱Model
    
    var body: some View {
        List {
            Section {
                👆BodyMassStepper()
                
                if 📱.🚩AbleBMI {
                    VStack(alignment: .leading) {
                        HStack(alignment: .firstTextBaseline, spacing: 4) {
                            Text("🌏Body Mass Index")
                            
                            Text("(" + 📱.🧍Height.description + "cm)")
                                .scaleEffect(0.8, anchor: .leading)
                        }
                        .font(.system(size: 14, weight: .semibold))
                        
                        Text(📱.📝BMI.description)
                            .font(.title)
                            .fontWeight(.bold)
                    }
                    .padding(12)
                    .padding(.leading, 32)
                    .monospacedDigit()
                    .foregroundStyle(.secondary)
                }
            } header: {
                Text("🌏Body Mass")
            }
            
            
            if 📱.🚩AbleBodyFat {
                👆BodyFatStepper()
            }
        }
        .listStyle(.plain)
        .clipped()
        .overlay(alignment: .bottom) {  // ☑️
            HStack(alignment: .bottom) {
                🛠MenuButton()
                
                Spacer()
                
                Button {
                    📱.👆Register()
                } label: {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 120))
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(.white, .pink)
                }
                .accessibilityLabel("🌏DONE")
                .padding()
                
                Spacer()
                
                💟JumpButton()
                    .foregroundColor(.pink)
            }
        }
        .fullScreenCover(isPresented: $📱.🚩ShowResult) {
            🗯ResultView()
        }
        .onAppear {
            📱.🏥RequestAuth(.bodyMass)
        }
        .onChange(of: 📱.🚩AbleBodyFat) { _ in
            📱.🏥RequestAuth(.bodyFatPercentage)
        }
        .onChange(of: 📱.🚩AbleBMI) { _ in
            📱.🏥RequestAuth(.bodyMassIndex)
        }
    }
}
