
import SwiftUI
import HealthKit

struct ContentView: View {
    @EnvironmentObject var 📱:📱Model
    
    var body: some View {
        List {
            👆BodyMassStepper()
            
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
