import SwiftUI
import HealthKit

struct ContentView: View {
    @EnvironmentObject var 📱: 📱AppModel
    @Environment(\.scenePhase) var scenePhase
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
            }
            .listStyle(.plain)
            .lineLimit(1)
            .minimumScaleFactor(0.3)
            .navigationTitle("Body Mass")
            .toolbar { 🛠MenuButton() } // ⚙️
            .safeAreaInset(edge: .bottom) {
                HStack(alignment: .firstTextBaseline) {
                    👆DoneButton()// ☑️
                    Spacer()
                    💟JumpButton()
                }
            }
        }
        .onAppear { 📱.🏥checkAuthOnLaunch() }
        .onAppear { 📱.🏥getLatestValue() }
        .onChange(of: self.scenePhase) {
            if $0 == .background {
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
    @Environment(\.scenePhase) var scenePhase
    @State private var 🚩showResult: Bool = false
    var body: some View {
        Button {
            Task {
                await 📱.👆register()
                self.🚩showResult = true
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
        .fullScreenCover(isPresented: self.$🚩showResult) {
            🗯ResultView()
        }
        .onChange(of: self.🚩showResult) {
            if $0 == true {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    📱.🏥getLatestValue()
                }
            }
        }
        .onChange(of: self.scenePhase) {
            if $0 == .background {
                self.🚩showResult = false
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
    @Environment(\.scenePhase) var scenePhase
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
            .onChange(of: self.scenePhase) {
                if $0 == .background {
                    📱.📅pickerValue = .now
                }
            }
        }
    }
}

struct 📉DifferenceView: View {
    @EnvironmentObject var 📱: 📱AppModel
    private var ⓣype: HKQuantityTypeIdentifier
    private var ⓛastSample: HKQuantitySample? { 📱.💾lastSamples[self.ⓣype] }
    private var 🪧description: String? {
        let 📉difference: Double
        switch self.ⓣype {
            case .bodyMass:
                guard let 📝lastValue = self.ⓛastSample?.quantity else { return nil }
                📉difference = round((📱.📝massValue - 📝lastValue.doubleValue(for: 📱.📏massUnit.hkunit)) * 100) / 100
            case .bodyMassIndex:
                guard let 📝lastValue = self.ⓛastSample?.quantity else { return nil }
                📉difference = round((📱.📝bmiValue - 📝lastValue.doubleValue(for: .count())) * 10) / 10
            case .bodyFatPercentage:
                guard let 📝lastValue = self.ⓛastSample?.quantity else { return nil }
                📉difference = round((📱.📝bodyFatValue - 📝lastValue.doubleValue(for: .percent())) * 1000) / 10
            default: return nil
        }
        switch 📉difference {
            case ..<0:
                if self.ⓣype == .bodyMass && 📱.🚩amount50g { return String(format: "%.2f", 📉difference) }
                return 📉difference.description
            case 0:
                if self.ⓣype == .bodyMass && 📱.🚩amount50g { return "0.00" }
                return "0.0"
            default:
                if self.ⓣype == .bodyMass && 📱.🚩amount50g { return "+" + String(format: "%.2f", 📉difference) }
                return "+" + 📉difference.description
        }
    }
    var body: some View {
        ZStack {
            Color.clear
            if !📱.🚩ableDatePicker || 📱.🚩datePickerIsAlmostNow {
                if let 🪧description {
                    VStack(spacing: 0) {
                        Text(🪧description)
                            .font(.subheadline.bold())
                            .monospacedDigit()
                            .frame(width: 72, height: 24, alignment: .bottomTrailing)
                        if let ⓛastSample {
                            Text(ⓛastSample.startDate, style: .offset)
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
        .animation(.default, value: self.🪧description == nil) //TODO: ShowResult削除のここの影響範囲を注視
        .animation(.default.speed(2), value: 📱.🚩datePickerIsAlmostNow)
    }
    init(_ ⓣype: HKQuantityTypeIdentifier) {
        self.ⓣype = ⓣype
    }
}
