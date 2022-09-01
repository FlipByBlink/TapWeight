
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
                
                📅DatePicker()
                    .padding(.top, 12)
                🏷LastEntryLabel()
                    .padding(.top, 4)
                    .padding(.bottom, 180)
            }
            .listStyle(.plain)
            .lineLimit(1)
            .minimumScaleFactor(0.3)
            .navigationTitle("Body Mass")
            .toolbar { 🛠MenuButton($📱.🚩ShowMenu) } // ⚙️
        }
        .overlay(alignment: .bottomLeading) { 👆DoneButton() }
        .overlay(alignment: .bottomTrailing) { 💟JumpButton() }
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
    var 📉DifferenceValue: Double? {
        guard let 📝LastValue = 📱.🕘LocalHistory.ⓛogs.last?.entry?.bmiValue else { return nil }
        return (round((📱.📝BMIValue - 📝LastValue)*10)/10)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: -4) {
            HStack(alignment: .firstTextBaseline, spacing: 4) {
                Text("Body Mass Index")
                    .font(.footnote.bold())
                
                Text("(" + 📱.🧍HeightValue.description + "cm)")
                    .font(.caption2.weight(.semibold))
                    .frame(maxHeight: 32)
            }
            
            HStack(alignment: .firstTextBaseline) {
                Text(📱.📝BMIValue.description)
                    .font(.title2)
                    .fontWeight(.heavy)
                
                Spacer()
                
                if let 📉 = 📉DifferenceValue {
                    Group {
                        switch 📉 {
                            case ..<0:
                                Text(📉.description)
                            case 0...:
                                Text("+" + 📉.description)
                                    .opacity(📉.isZero ? 0 : 1 )
                            default: Text("🐛")
                        }
                    }
                    .font(.body.bold())
                    .monospacedDigit()
                    .foregroundStyle(.tertiary)
                    .minimumScaleFactor(0.1)
                    .frame(maxWidth: 48 ,maxHeight: 32)
                    .padding(.trailing)
                    .opacity(📱.🕘LocalHistory.🚩CanceledLastEntry ? 1 : 0)
                }
            }
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
                .foregroundColor(.pink)
                .opacity(0.8)
                .padding(2)
        }
        .accessibilityLabel("Open \"Health\" app")
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
            .listRowSeparator(.hidden)
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
    
    var body: some View {
        if let ⓛastEntry = 📱.🕘LocalHistory.ⓛogs.last?.entry {
            HStack {
                Spacer()
                VStack(alignment: .trailing) {
                    Text(ⓛastEntry.date.formatted(date: .abbreviated, time: .omitted))
                        .font(.footnote.bold())
                    Text(ⓛastEntry.date.formatted(date: .omitted, time: .shortened))
                        .font(.caption.bold())
                }
            }
            .foregroundStyle(.tertiary)
            .padding(.trailing, 12)
            .minimumScaleFactor(0.3)
            .listRowSeparator(.hidden)
            .opacity(📱.🕘LocalHistory.🚩CanceledLastEntry ? 1 : 0)
        }
    }
}
