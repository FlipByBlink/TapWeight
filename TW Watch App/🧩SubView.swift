import SwiftUI

struct 👆DoneButton: View { // ☑️
    @EnvironmentObject var 📱: 📱AppModel
    var body: some View {
        Button {
            📱.👆register()
        } label: {
            Label("Register", systemImage: "checkmark.circle.fill")
                .symbolRenderingMode(.palette)
                .foregroundStyle(.white, .pink)
        }
        .accessibilityLabel("DONE")
        .fullScreenCover(isPresented: $📱.🚩showResult) { 🗯ResultView() }
    }
}

struct 🎚️BodyMassStepper: View {
    @EnvironmentObject var 📱: 📱AppModel
    private var ⓘnputIsValid: Bool { 📱.ⓜassInputIsValid }
    private var ⓤnitDescription: String { 📱.ⓜassUnit?.description ?? "kg" }
    private var ⓓifferenceDescription: String? { 📱.ⓓifferencesDescription[.bodyMass] }
    private var ⓛastSampleDate: Date? { 📱.ⓛatestSamplesDate[.bodyMass] }
    var body: some View {
        Section {
            Stepper {
                Text(📱.ⓜassInputDescription + self.ⓤnitDescription)
                    .monospacedDigit()
                    .minimumScaleFactor(0.1)
                    .opacity(self.ⓘnputIsValid ? 1 : 0.2)
                    .animation(.default, value: self.ⓘnputIsValid)
            } onIncrement: {
                📱.🎚️changeMassValue(.increment)
            } onDecrement: {
                📱.🎚️changeMassValue(.decrement)
            }
            .lineLimit(1)
        } header: {
            Text("Body Mass")
        } footer: {
            if let ⓓifferenceDescription, let ⓛastSampleDate {
                Text(ⓓifferenceDescription)
                +
                Text(ⓛastSampleDate, style: .offset)
            }
        }
    }
}

struct 🎚️BodyFatStepper: View {
    @EnvironmentObject var 📱: 📱AppModel
    private var ⓘnputIsValid: Bool { 📱.ⓑodyFatInputIsValid }
    var body: some View {
//        if 📱.🚩ableBodyFat {
            Section {
                Stepper {
                    Text(📱.ⓑodyFatInputDescription + "%")
                        .monospacedDigit()
                        .opacity(self.ⓘnputIsValid ? 1 : 0.2)
                        .minimumScaleFactor(0.1)
                    //📉DifferenceView(.bodyFatPercentage)
                } onIncrement: {
                    📱.🎚️changeBodyFatValue(.increment)
                } onDecrement: {
                    📱.🎚️changeBodyFatValue(.decrement)
                }
                .lineLimit(1)
                .animation(.default, value: self.ⓘnputIsValid)
            } header: {
                Text("Body Fat Percentage")
            }
//        }
    }
}

struct 🪧BMIView: View {
    @EnvironmentObject var 📱: 📱AppModel
    private var ⓘnputValue: Double? { 📱.ⓑmiInputValue }
    private var ⓗeightQuantityDescription: String? { 📱.ⓗeightQuantityDescription }
    private var ⓓifferenceDescription: String? { 📱.ⓓifferencesDescription[.bodyMassIndex] }
    private var ⓛastSampleDate: Date? { 📱.ⓛatestSamplesDate[.bodyMassIndex] }
    var body: some View {
//        if 📱.🚩ableBMI {
            if let ⓘnputValue, let ⓗeightQuantityDescription {
                Section {
                    LabeledContent(ⓘnputValue.description, value: ⓗeightQuantityDescription)
                        .monospacedDigit()
                } header: {
                    Text("Body Mass Index")
                } footer: {
                    if let ⓓifferenceDescription, let ⓛastSampleDate {
                        Text(ⓓifferenceDescription + "  ")
                        +
                        Text(ⓛastSampleDate, style: .offset)
                    }
                }
            } else {
                Text("__Body Mass Index:__ Height data is nothing on \"Health\" app. Register height data.")
                    .font(.footnote)
                    .foregroundStyle(.tertiary)
            }
//        }
    }
}

struct 🪧LBMView: View {
    @EnvironmentObject var 📱: 📱AppModel
    private var ⓘnputDescription: String? { 📱.ⓛbmInputDescription }
    var body: some View {
//        if 📱.🚩ableLBM {
            if let ⓘnputDescription {
                HStack {
                    VStack(alignment: .leading, spacing: -2) {
                        Text("Lean Body Mass")
                        Text(ⓘnputDescription)
                            .fontWeight(.heavy)
                    }
                    .monospacedDigit()
                }
                .foregroundStyle(.secondary)
            } else {
                Text("__Lean Body Mass:__ Error")
            }
//        }
    }
}

struct 🗯ResultView: View {
    @EnvironmentObject var 📱: 📱AppModel
    private var ⓒanceled: Bool { 📱.🚩completedCancellation }
    var body: some View {
        NavigationView {
            ZStack {
                Rectangle()
                    .foregroundColor(.pink)
                    .ignoresSafeArea()
                VStack(spacing: 16) {
                    Image(systemName: "checkmark")
                        .font(.system(size: 96).weight(.semibold))
                    Text("DONE!")
                        .strikethrough(self.ⓒanceled)
                        .font(.system(size: 96).weight(.black))
                    Text("Registration for \"Health\" app")
                        .strikethrough(self.ⓒanceled)
                        .font(.title3.weight(.semibold))
                    self.🗯SummaryText()
                }
                .lineLimit(1)
                .minimumScaleFactor(0.3)
                .padding()
                .padding(.bottom, 120)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .opacity(self.ⓒanceled ? 0.5 : 1)
                .overlay(alignment: .bottom) {
                    if self.ⓒanceled { Text("Canceled") }
                }
                .toolbar {
                    self.🗑cancelButton()
                }
            }
            .animation(.default, value: self.ⓒanceled)
            .navigationBarTitleDisplayMode(.inline)
        }
        .preferredColorScheme(.dark)
        .modifier(🚨CancellationErrorAlert())
    }
    private func 🗯SummaryText() -> some View {
        Group {
            Text(📱.ⓡesultSummaryDescription ?? "🐛")
                .strikethrough(self.ⓒanceled)
                .font(.body.bold())
            if 📱.🚩ableDatePicker {
                if let ⓓate = 📱.📨registeredSamples.first?.startDate as? Date {
                    Text(ⓓate.formatted(date: .abbreviated, time: .shortened))
                        .strikethrough(self.ⓒanceled)
                        .font(.subheadline.weight(.semibold))
                        .padding(.horizontal)
                }
            }
        }
        .opacity(0.75)
        .padding(.horizontal, 42)
    }
    private func 🗑cancelButton() -> some ToolbarContent {
        ToolbarItem {
            Button {
                📱.🗑cancel()
            } label: {
                Image(systemName: "arrow.uturn.backward.circle.fill")
                    .symbolRenderingMode(.hierarchical)
                    .foregroundColor(.primary)
                    .font(.title)
            }
            .disabled(self.ⓒanceled)
            .opacity(self.ⓒanceled ? 0.5 : 1)
            .accessibilityLabel("Cancel")
        }
    }
}

struct 🚨RegistrationErrorAlert: ViewModifier {
    @EnvironmentObject var 📱: 📱AppModel
    func body(content: Content) -> some View {
        content
            .alert("⚠️ Failed registration", isPresented: $📱.🚩alertRegistrationError) {
                Link(destination: URL(string: "x-apple-health://")!) {
                    Label("Open \"Health\" app", systemImage: "app")
                }
            } message: {
                Text(📱.🚨registrationError?.message ?? "🐛")
            }
    }
}

struct 🚨CancellationErrorAlert: ViewModifier {
    @EnvironmentObject var 📱: 📱AppModel
    func body(content: Content) -> some View {
        content
            .alert("⚠️ Failed cancellation", isPresented: $📱.🚩alertCancellationError) {
                EmptyView()
            } message: {
                Text(📱.🚨cancellationError?.message ?? "🐛")
            }
    }
}
