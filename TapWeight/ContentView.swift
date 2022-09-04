
import SwiftUI
import HealthKit

struct ContentView: View {
    @EnvironmentObject var 📱: 📱AppModel
    @Environment(\.scenePhase) var 🚥Phase: ScenePhase
    
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
                    .padding(.bottom, 180)
            }
            .listStyle(.plain)
            .lineLimit(1)
            .minimumScaleFactor(0.3)
            .navigationTitle("Body Mass")
            .toolbar { 🛠MenuButton() } // ⚙️
        }
        .overlay(alignment: .bottomLeading) { 👆DoneButton() } // ☑️
        .overlay(alignment: .bottomTrailing) { 💟JumpButton() }
        .onAppear { 📱.🏥CheckAuthOnLaunch() }
        .onAppear { 📱.🏥GetLatestValue() }
        .onChange(of: 🚥Phase) { _ in
            if 🚥Phase == .background {
                📱.🏥GetLatestValue()
            }
        }
    }
}


struct 🪧BMIView: View {
    @EnvironmentObject var 📱: 📱AppModel
    
    var body: some View {
        HStack {
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
            .monospacedDigit()
            
            Spacer()
            📉DifferenceView(.bmi)
                .padding(.trailing, 12)
        }
        .padding(.vertical, 4)
        .padding(.leading, 32)
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
        .fullScreenCover(isPresented: $📱.🚩ShowResult) {
            🗯ResultView()
        }
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
            .opacity(📱.🚩DatePickerIsAlmostNow ? 0.4 : 1)
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


struct 📉DifferenceView: View { //TODO: 実装再検討
    @EnvironmentObject var 📱: 📱AppModel
    var ⓣype: 🅃ype
    var 🪧Description: String? {
        let 📉Difference: Double
        switch ⓣype {
            case .mass:
                guard let 📝LastValue = lastSample?.quantity else { return nil }
                📉Difference = (round((📱.📝MassValue - 📝LastValue.doubleValue(for: 📱.📏MassUnit.hkunit))*100)/100)
            case .bmi:
                guard let 📝LastValue = lastSample?.quantity else { return nil }
                📉Difference = (round((📱.📝BMIValue - 📝LastValue.doubleValue(for: .count()))*10)/10)
            case .bodyFat:
                guard let 📝LastValue = lastSample?.quantity else { return nil }
                📉Difference = (round((📱.📝BodyFatValue - 📝LastValue.doubleValue(for: .percent()))*1000)/10)
        }
        
        switch 📉Difference {
            case ..<0:
                guard ⓣype == .mass && 📱.🚩Amount50g else { return 📉Difference.description }
                return String(format: "%.2f", 📉Difference)
            case 0: return "0.0"
            default:
                guard ⓣype == .mass && 📱.🚩Amount50g else { return "+" + 📉Difference.description }
                return "+" + String(format: "%.2f", 📉Difference)
        }
    }
    
    var lastSample: HKQuantitySample? {
        switch ⓣype {
            case .mass: return 📱.💾LastMassSample
            case .bmi: return 📱.💾LastBMISample
            case .bodyFat: return 📱.💾LastBodyFatSample
        }
    }
    
    var body: some View {
        ZStack {
            Color.clear
            if 📱.🚩DatePickerIsAlmostNow {
                if let 🪧 = 🪧Description {
                    VStack(spacing: 0) {
                        Text(🪧)
                            .font(.subheadline.bold())
                            .monospacedDigit()
                            .frame(width: 48, height: 24, alignment: .bottomTrailing)
                        
                        if let sample = lastSample {
                            Text(sample.startDate, style: .offset) //style: .relative
                                .font(.caption.bold())
                                .frame(width: 48, height: 24, alignment: .topTrailing)
                        }
                    }
                    .foregroundStyle(.tertiary)
                    .minimumScaleFactor(0.1)
                }
            }
        }
        .frame(width: 48, height: 48)
        .animation(📱.🚩ShowResult ? .default : .default.speed(2), value: 🪧Description == nil)
        .animation(.default.speed(2), value: 📱.🚩DatePickerIsAlmostNow)
    }
    
    enum 🅃ype {
        case mass
        case bmi
        case bodyFat
    }
    
    init(_ ⓣype: 🅃ype) {
        self.ⓣype = ⓣype
    }
}
