
import SwiftUI
import HealthKit

struct ContentView: View {
    @EnvironmentObject var 📱: 📱AppModel
    
    var body: some View {
        List {
            Section {
                👆BodyMassStepper()
                
                if 📱.🚩AbleBMI { 🪧BMIView() }
            } header: {
                Text("Body Mass")
            }
            
            if 📱.🚩AbleBodyFat { 👆BodyFatStepper() }
        }
        .listStyle(.plain)
        .clipped()
        .overlay(alignment: .bottomLeading) { 🛠MenuButton() }
        .overlay(alignment: .bottom) { 👆DoneButton() }
        .overlay(alignment: .bottomTrailing) {
            💟JumpButton()
                .foregroundColor(.pink)
                .opacity(0.66)
        }
        .fullScreenCover(isPresented: $📱.🚩ShowResult) {
            🗯ResultView()
        }
        .onAppear { 📱.🏥RequestAuth(.bodyMass) }
        .onChange(of: 📱.🚩AbleBodyFat) { _ in
            📱.🏥RequestAuth(.bodyFatPercentage)
        }
        .onChange(of: 📱.🚩AbleBMI) { _ in
            📱.🏥RequestAuth(.bodyMassIndex)
        }
    }
}


struct 🪧BMIView: View {
    @EnvironmentObject var 📱: 📱AppModel
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .firstTextBaseline, spacing: 4) {
                Text("Body Mass Index")
                
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
}


struct 👆DoneButton: View { // ☑️
    @EnvironmentObject var 📱: 📱AppModel
    
    var body: some View {
        Button {
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
}


struct 💟JumpButton: View {
    var body: some View {
        Link(destination: URL(string: "x-apple-health://")!) {
            Image(systemName: "app")
                .imageScale(.large)
                .overlay {
                    Image(systemName: "heart")
                        .imageScale(.small)
                }
                .font(.largeTitle)
                .padding(24)
        }
        .accessibilityLabel("Open \"Health\" app")
    }
}
