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
    private var ⓓifference: 🄳ifference? { 📱.ⓓifference[.bodyMass] }
    var body: some View {
        Section {
            VStack {
                Stepper {
                    Text(📱.ⓜassInputDescription + self.ⓤnitDescription)
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .monospacedDigit()
                        .minimumScaleFactor(0.5)
                        .opacity(self.ⓘnputIsValid ? 1 : 0.2)
                        .animation(.default, value: self.ⓘnputIsValid)
                } onIncrement: {
                    📱.🎚️changeMassValue(.increment)
                } onDecrement: {
                    📱.🎚️changeMassValue(.decrement)
                }
                if let ⓓifference {
                    LabeledContent(ⓓifference.valueDescription) {
                        Text(ⓓifference.lastSampleDate, style: .offset)
                    }
                    .padding(.horizontal)
                    .font(.caption2.monospaced())
                    .foregroundStyle(.secondary)
                }
            }
            .lineLimit(1)
        } header: {
            Text("Body Mass")
                .bold()
        }
    }
}

struct 🎚️BodyFatStepper: View {
    @EnvironmentObject var 📱: 📱AppModel
    private var ⓘnputIsValid: Bool { 📱.ⓑodyFatInputIsValid }
    private var ⓓifference: 🄳ifference? { 📱.ⓓifference[.bodyFatPercentage] }
    var body: some View {
//        if 📱.🚩ableBodyFat {
            Section {
                VStack {
                    Stepper {
                        Text(📱.ⓑodyFatInputDescription + "%")
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .monospacedDigit()
                            .opacity(self.ⓘnputIsValid ? 1 : 0.2)
                            .minimumScaleFactor(0.1)
                    } onIncrement: {
                        📱.🎚️changeBodyFatValue(.increment)
                    } onDecrement: {
                        📱.🎚️changeBodyFatValue(.decrement)
                    }
                    .lineLimit(1)
                    .animation(.default, value: self.ⓘnputIsValid)
                    if let ⓓifference {
                        LabeledContent(ⓓifference.valueDescription) {
                            Text(ⓓifference.lastSampleDate, style: .offset)
                        }
                        .padding(.horizontal)
                        .font(.caption2.monospaced())
                        .foregroundStyle(.secondary)
                    }
                }
            } header: {
                Text("Body Fat Percentage")
                    .bold()
            }
//        }
    }
}

struct 🪧BMIView: View {
    @EnvironmentObject var 📱: 📱AppModel
    private var ⓘnputValue: Double? { 📱.ⓑmiInputValue }
    private var ⓗeightQuantityDescription: String? { 📱.ⓗeightQuantityDescription }
    private var ⓓifference: 🄳ifference? { 📱.ⓓifference[.bodyMass] }
    var body: some View {
//        if 📱.🚩ableBMI {
            if let ⓘnputValue, let ⓗeightQuantityDescription {
                Section {
                    VStack {
                        HStack(alignment: .firstTextBaseline) {
                            Text(ⓘnputValue.description)
                                .monospacedDigit()
                                .fontWeight(.heavy)
                            Text("(\(ⓗeightQuantityDescription))")
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                        }
                        if let ⓓifference {
                            LabeledContent(ⓓifference.valueDescription) {
                                Text(ⓓifference.lastSampleDate, style: .offset)
                            }
                            .padding(.horizontal)
                            .font(.caption2.monospaced())
                            .foregroundStyle(.secondary)
                        }
                    }
                } header: {
                    Text("Body Mass Index")
                        .bold()
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
    private var ⓓifference: 🄳ifference? { 📱.ⓓifference[.leanBodyMass] }
    var body: some View {
//        if 📱.🚩ableLBM {
            if let ⓘnputDescription {
                Section {
                    VStack {
                        Text(ⓘnputDescription)
                            .fontWeight(.heavy)
                            .monospacedDigit()
                        if let ⓓifference {
                            LabeledContent(ⓓifference.valueDescription) {
                                Text(ⓓifference.lastSampleDate, style: .offset)
                            }
                            .padding(.horizontal)
                            .font(.caption2.monospaced())
                            .foregroundStyle(.secondary)
                        }
                    }
                } header: {
                    Text("Lean Body Mass")
                        .bold()
                }
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
