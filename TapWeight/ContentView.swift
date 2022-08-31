
import SwiftUI
import HealthKit

struct ContentView: View {
    @EnvironmentObject var 📱: 📱AppModel
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    👆BodyMassStepper()
                    
                    if 📱.🚩AbleBMI { 🪧BMIView() }
                }
                
                if 📱.🚩AbleBodyFat { 👆BodyFatStepper() }
                
                VStack {
                    🏷LastEntryLabel()
                    📅DatePicker()
                }
                .padding(.top, 12)
                .listRowSeparator(.hidden)
            }
            .listStyle(.plain)
            .lineLimit(1)
            .minimumScaleFactor(0.3)
            .navigationTitle("Body Mass")
            .toolbar { 🛠MenuButton($📱.🚩ShowMenu) } // ⚙️
        }
        .overlay(alignment: .bottomLeading) { 👆DoneButton() }
        .overlay(alignment: .bottomTrailing) { 💟JumpButtonOnMainView() }
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
        VStack(alignment: .leading, spacing: -4) {
            HStack(alignment: .firstTextBaseline, spacing: 4) {
                Text("Body Mass Index")
                    .font(.footnote.bold())
                
                Text("(" + 📱.🧍HeightValue.description + "cm)")
                    .font(.caption2.weight(.semibold))
                    .frame(maxHeight: 32)
            }
            
            Text(📱.📝BMIValue.description)
                .font(.title2)
                .fontWeight(.heavy)
        }
        .padding(.vertical, 4)
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
        .background {
            Circle()
                .foregroundStyle(.background)
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
                .padding(2)
        }
        .accessibilityLabel("Open \"Health\" app")
    }
}

struct 💟JumpButtonOnMainView: View {
    var body: some View {
        💟JumpButton()
            .foregroundColor(.pink)
            .opacity(0.8)
            .background {
                RoundedRectangle(cornerRadius: 16)
                    .foregroundStyle(.background)
            }
            .padding(22)
    }
}


struct 📅DatePicker: View {
    @EnvironmentObject var 📱: 📱AppModel
    @Environment(\.scenePhase) var 🚥Phase: ScenePhase
    
    var body: some View {
        if 📱.🚩AbleDatePicker {
            VStack(alignment: .trailing, spacing: 16) {
                DatePicker(selection: $📱.📅PickerValue, in: ...Date.now, displayedComponents: .date) {
                    HStack {
                        Spacer()
                        Image(systemName: "calendar")
                    }
                }
                    
                DatePicker(selection: $📱.📅PickerValue, in: ...Date.now, displayedComponents: .hourAndMinute) {
                    HStack {
                        Spacer()
                        Image(systemName: "clock")
                    }
                }
            }
            .opacity(📱.📅PickerValue.timeIntervalSinceNow < -300 ? 1 : 0.4)
            .padding(.trailing, 8)
            .padding(.bottom, 180)
            .onChange(of: 🚥Phase) { _ in
                if 🚥Phase == .background {
                    📱.📅PickerValue = .now
                }
            }
        }
    }
}


struct 🏷LastEntryLabel: View {
    @EnvironmentObject var 📱: 📱AppModel
    
    var 🪧Description: String {
        if let ⓛastEntry = 📱.🕘LocalHistory.ⓛogs.last?.entry {
            var 🪧 = "(" + ⓛastEntry.date.formatted(date: .abbreviated, time: .shortened) + "  "
            🪧 += ⓛastEntry.massSample.value.description + ⓛastEntry.massSample.unit.rawValue
            if 📱.🚩AbleBMI {
                if let ⓥalue = ⓛastEntry.bmiValue {
                    🪧 += "  " + ⓥalue.description
                }
            }
            if 📱.🚩AbleBodyFat {
                if let ⓥalue = ⓛastEntry.bodyFatValue {
                    🪧 += "  " + (round(ⓥalue*1000)/10).description + "%"
                }
            }
            🪧 += ")"
            return 🪧
        } else {
            return "🐛"
        }
    }
    
    var body: some View {
        if 📱.🕘LocalHistory.ⓛogs.last?.entry?.cancellation == false {
            HStack {
                Spacer()
                Text(🪧Description)
            }
            .foregroundStyle(.tertiary)
            .padding(.trailing, 10)
            .minimumScaleFactor(0.3)
            .font(.footnote.weight(.medium))
        } else {
            EmptyView()
        }
    }
}
