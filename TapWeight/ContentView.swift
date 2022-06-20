
import SwiftUI
import HealthKit

struct ContentView: View {
    @EnvironmentObject var 📱: 📱AppModel
    
    var body: some View {
        List {
            👆BodyMassStepper()
            
            if 📱.🚩AbleBodyFat {
                👆BodyFatStepper()
            }
        }
        .listStyle(.plain)
        .clipped()
        .overlay(alignment: .bottomLeading) {
            🛠MenuButton()
                .opacity(0.66)
        }
        .overlay(alignment: .bottom) {
            Button { // ☑️
                Task {
                    await 📱.👆Register()
                }
            } label: {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 120))
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(.white, .pink)
            }
            .accessibilityLabel("DONE")
            .padding()
        }
        .overlay(alignment: .bottomTrailing) {
            💟JumpButton()
                .foregroundColor(.pink)
                .opacity(0.66)
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
