
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
                    if 📱.🚩ableBMI { 🪧BMIView() }
                }
                
                if 📱.🚩ableBodyFat { 👆BodyFatStepper() }
                
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
        .onAppear { 📱.🏥checkAuthOnLaunch() }
        .onAppear { 📱.🏥getLatestValue() }
        .onChange(of: 🚥Phase) { _ in
            if 🚥Phase == .background {
                📱.🏥getLatestValue()
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
                    Text("(" + 📱.🧍heightValue.description + "cm)")
                        .font(.caption2.weight(.semibold))
                        .frame(maxHeight: 32)
                }
                
                Text(📱.📝bmiValue.description)
                    .font(.title2)
                    .fontWeight(.heavy)
            }
            .monospacedDigit()
            
            Spacer()
            📉DifferenceView(.bodyMassIndex)
                .padding(.trailing, 12)
        }
        .padding(.vertical, 4)
        .padding(.leading, 32)
        .foregroundStyle(.secondary)
    }
}

struct 👆DoneButton: View { // ☑️
    @EnvironmentObject var 📱: 📱AppModel
    @Environment(\.scenePhase) var 🚥Phase: ScenePhase
    @State private var 🚩ShowResult: Bool = false
    var body: some View {
        Button {
            Task {
                await 📱.👆register()
                🚩ShowResult = true
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
        .fullScreenCover(isPresented: $🚩ShowResult) {
            🗯ResultView()
        }
        .onChange(of: 🚩ShowResult) { 🆕 in
            if 🆕 == true {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    📱.🏥getLatestValue()
                }
            }
        }
        .onChange(of: 🚥Phase) { 🚥 in
            if 🚥 == .background {
                🚩ShowResult = false
            }
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
        if 📱.🚩ableDatePicker {
            VStack(alignment: .trailing, spacing: 16) {
                DatePicker(selection: $📱.📅pickerValue, in: ...Date.now, displayedComponents: .date) {
                    HStack {
                        Spacer()
                        Image(systemName: "calendar")
                    }
                }
                    
                DatePicker(selection: $📱.📅pickerValue, in: ...Date.now, displayedComponents: .hourAndMinute) {
                    HStack {
                        Spacer()
                        Image(systemName: "clock")
                    }
                }
            }
            .opacity(📱.🚩datePickerIsAlmostNow ? 0.4 : 1)
            .padding(.trailing, 8)
            .listRowSeparator(.hidden)
            .onChange(of: 🚥Phase) { _ in
                if 🚥Phase == .background {
                    📱.📅pickerValue = .now
                }
            }
        }
    }
}

struct 📉DifferenceView: View {
    @EnvironmentObject var 📱: 📱AppModel
    var ⓣype: HKQuantityTypeIdentifier
    var ⓛastSample: HKQuantitySample? { 📱.💾lastSamples[ⓣype] }
    var 🪧Description: String? {
        let 📉Difference: Double
        switch ⓣype {
            case .bodyMass:
                guard let 📝LastValue = ⓛastSample?.quantity else { return nil }
                📉Difference = round((📱.📝massValue - 📝LastValue.doubleValue(for: 📱.📏massUnit.hkunit))*100)/100
            case .bodyMassIndex:
                guard let 📝LastValue = ⓛastSample?.quantity else { return nil }
                📉Difference = round((📱.📝bmiValue - 📝LastValue.doubleValue(for: .count()))*10)/10
            case .bodyFatPercentage:
                guard let 📝LastValue = ⓛastSample?.quantity else { return nil }
                📉Difference = round((📱.📝bodyFatValue - 📝LastValue.doubleValue(for: .percent()))*1000)/10
            default: return nil
        }
        
        switch 📉Difference {
            case ..<0:
                if ⓣype == .bodyMass && 📱.🚩amount50g { return String(format: "%.2f", 📉Difference) }
                return 📉Difference.description
            case 0:
                if ⓣype == .bodyMass && 📱.🚩amount50g { return "0.00" }
                return "0.0"
            default:
                if ⓣype == .bodyMass && 📱.🚩amount50g { return "+" + String(format: "%.2f", 📉Difference) }
                return "+" + 📉Difference.description
        }
    }
    
    var body: some View {
        ZStack {
            Color.clear
            if !📱.🚩ableDatePicker || 📱.🚩datePickerIsAlmostNow {
                if let 🪧 = 🪧Description {
                    VStack(spacing: 0) {
                        Text(🪧)
                            .font(.subheadline.bold())
                            .monospacedDigit()
                            .frame(width: 72, height: 24, alignment: .bottomTrailing)
                        
                        if let ⓢample = ⓛastSample {
                            Text(ⓢample.startDate, style: .offset)
                                .font(.caption.bold())
                                .frame(width: 72, height: 24, alignment: .topTrailing)
                        }
                    }
                    .foregroundStyle(.tertiary)
                    .minimumScaleFactor(0.1)
                }
            }
        }
        .frame(width: 72, height: 48)
        .animation(.default, value: 🪧Description == nil) //TODO: ShowResult削除のここの影響範囲を注視
        .animation(.default.speed(2), value: 📱.🚩datePickerIsAlmostNow)
    }
    
    init(_ ⓣype: HKQuantityTypeIdentifier) {
        self.ⓣype = ⓣype
    }
}
