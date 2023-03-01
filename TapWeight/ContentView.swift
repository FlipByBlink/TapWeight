import SwiftUI
import HealthKit

struct ContentView: View {
    @EnvironmentObject var 📱: 📱AppModel
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
            .minimumScaleFactor(0.3)
            .navigationTitle("Body Mass")
            .toolbar { 🛠MenuButton() } // ⚙️
            .safeAreaInset(edge: .bottom) {
                HStack(alignment: .firstTextBaseline) {
                    👆DoneButton() // ☑️
                    Spacer()
                    💟JumpButton()
                }
            }
        }
    }
}

struct 🪧BMIView: View {
    @EnvironmentObject var 📱: 📱AppModel
    private var ⓘnputValue: Double? { 📱.ⓑmiInputValue }
    private var ⓓescription: String? { 📱.📦latestSamples[.height]?.quantity.description }
    var body: some View {
        if let ⓘnputValue, let ⓓescription {
            HStack {
                VStack(alignment: .leading, spacing: -4) {
                    HStack(alignment: .firstTextBaseline, spacing: 4) {
                        Text("Body Mass Index")
                            .font(.footnote.bold())
                        Text("(\(ⓓescription))")
                            .font(.caption2.weight(.semibold))
                            .frame(maxHeight: 32)
                    }
                    Text(ⓘnputValue.description)
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
        } else {
            GroupBox {
                Text("Height data is nothing on \"Health\" app. Register height data on \"Health\" app.")
            } label: {
                Text("Body Mass Index")
            }
            .foregroundStyle(.secondary)
        }
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
        .onChange(of: self.scenePhase) {
            if $0 == .background {
                self.🚩showResult = false
                📱.📝resetPickerValues()
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
                DatePicker(selection: $📱.📅datePickerValue, in: ...Date.now, displayedComponents: .date) {
                    HStack {
                        Spacer()
                        Image(systemName: "calendar")
                    }
                }
                DatePicker(selection: $📱.📅datePickerValue, in: ...Date.now, displayedComponents: .hourAndMinute) {
                    HStack {
                        Spacer()
                        Image(systemName: "clock")
                    }
                }
            }
            .opacity(📱.ⓓatePickerIsAlmostNow ? 0.4 : 1)
            .padding(.trailing, 8)
            .listRowSeparator(.hidden)
            .onChange(of: self.scenePhase) {
                if $0 == .background {
                    📱.📅datePickerValue = .now
                }
            }
        }
    }
}

struct 📉DifferenceView: View {
    @EnvironmentObject var 📱: 📱AppModel
    private var ⓣype: HKQuantityTypeIdentifier
    private var ⓓescription: String? { 📱.ⓓifferenceDescriptions[self.ⓣype] }
    private var ⓛastSampleDate: Date? { 📱.📦latestSamples[self.ⓣype]?.startDate }
    var body: some View {
        ZStack {
            Color.clear
            if !📱.🚩ableDatePicker || 📱.ⓓatePickerIsAlmostNow {
                if let ⓓescription, let ⓛastSampleDate {
                    VStack(spacing: 0) {
                        Text(ⓓescription)
                            .font(.subheadline.bold())
                            .monospacedDigit()
                            .frame(width: 72, height: 24, alignment: .bottomTrailing)
                        Text(ⓛastSampleDate, style: .offset)
                            .font(.caption.bold())
                            .frame(width: 72, height: 24, alignment: .topTrailing)
                    }
                    .foregroundStyle(.tertiary)
                    .minimumScaleFactor(0.1)
                }
            }
        }
        .frame(width: 72, height: 48)
        .animation(.default.speed(2), value: 📱.ⓓatePickerIsAlmostNow)
    }
    init(_ ⓣype: HKQuantityTypeIdentifier) {
        self.ⓣype = ⓣype
    }
}
