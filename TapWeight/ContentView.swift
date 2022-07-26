
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
            
            📅DatePicker()
        }
        .listStyle(.plain)
        .clipped()
        .overlay(alignment: .top) { 📅LastDateLabel() }
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


//TODO: 日時入力のモデル部分を実装
struct 📅DatePicker: View {
    @EnvironmentObject var 📱: 📱AppModel
    @State private var 📅Date = Date.now
    
    var body: some View {
        HStack {
            Spacer()
            VStack(alignment: .trailing, spacing: 16) {
                DatePicker(selection: $📅Date, displayedComponents: .date) {
                    HStack {
                        Spacer()
                        Image(systemName: "calendar")
                    }
                }
                    
                DatePicker(selection: $📅Date, displayedComponents: .hourAndMinute) {
                    HStack {
                        Spacer()
                        Image(systemName: "clock")
                    }
                }
            }
            .padding()
            .padding(.bottom, 180)
        }
        .listRowSeparator(.hidden)
    }
}


struct 📅LastDateLabel: View {
    @EnvironmentObject var 📱: 📱AppModel
    @State private var 🚩Show: Bool = true
    @State private var 📅LastDate: Date? = UserDefaults.standard.object(forKey: "LastDate") as? Date
    
    var body: some View {
        if let 📅 = 📅LastDate {
            Text(📅.formatted(date: .numeric, time: .shortened))
                .font(.caption.weight(.medium))
                .minimumScaleFactor(0.1)
                .foregroundStyle(.secondary)
                .padding(8)
                .opacity(🚩Show ? 1 : 0)
                .animation(.default.speed(0.5), value: 🚩Show)
                .onChange(of: 📱.📝BodyMass) { 📝 in
                    if 📝 != 📱.💾BodyMass {
                        🚩Show = false
                    }
                }
                .onChange(of: 📱.📝BodyFat) { 📝 in
                    if 📝 != 📱.💾BodyFat {
                        🚩Show = false
                    }
                }
                .onChange(of: 📱.🚩ShowResult) { _ in
                    🚩Show = false
                }
        }
    }
}
