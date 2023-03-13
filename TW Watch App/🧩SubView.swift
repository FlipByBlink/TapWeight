import SwiftUI

struct 🚨CheckCondition: ViewModifier {
    @EnvironmentObject var 📱: 📱AppModel
    @State private var 🚩finishedFirstQuary: Bool = false
    private var ⓘnvalidCategories: [🏥Category] {
        var ⓥalue: [🏥Category] = []
        if 📱.📦latestSamples[.bodyMass] == nil {
            ⓥalue += [.bodyMass]
        }
        if 📱.🚩ableBMI && (📱.📦latestSamples[.height] == nil) {
            ⓥalue += [.height]
        }
        if 📱.🚩ableBodyFat && (📱.📦latestSamples[.bodyFatPercentage] == nil) {
            ⓥalue += [.bodyFatPercentage]
        }
        return ⓥalue
    }
    private var ⓘnputIsInvalid: Bool { !self.ⓘnvalidCategories.isEmpty }
    func body(content: Content) -> some View {
        Group {
            if self.🚩finishedFirstQuary && self.ⓘnputIsInvalid {
                self.ⓔrrorView()
            } else {
                content
            }
        }
        .task {
            await 📱.ⓛoadLatestSamples()
            self.🚩finishedFirstQuary = true
        }
    }
    private func ⓔrrorView() -> some View {
        ScrollView {
            Text("Error")
                .font(.headline)
            Text("Did not find the recent data. Please register your data on the iPhone first. Or check authentication on Apple Watch.")
            ForEach(self.ⓘnvalidCategories, id: \.identifier) { ⓒategory in
                Text("・" + ⓒategory.localizedString)
            }
        }
        .foregroundStyle(.secondary)
    }
}

struct 🄰uthManager: ViewModifier {
    @EnvironmentObject var 📱: 📱AppModel
    @Environment(\.scenePhase) var scenePhase
    func body(content: Content) -> some View {
        content
            .onChange(of: self.scenePhase) {
                if $0 == .active { 📱.ⓡequestAuths() }
            }
    }
}

struct 👆DoneButton: View { // ☑️
    @EnvironmentObject var 📱: 📱AppModel
    var body: some View {
        Button {
            📱.👆register()
        } label: {
            Label("Register", systemImage: "checkmark")
        }
        .listItemTint(.pink)
        .foregroundStyle(.white)
        .fontWeight(.semibold)
        .accessibilityLabel("Register")
        .fullScreenCover(isPresented: $📱.🚩showResult) { 🗯ResultView() }
    }
}

struct 🎚️BodyMassStepper: View {
    @EnvironmentObject var 📱: 📱AppModel
    private var ⓘnputIsValid: Bool { 📱.ⓜassInputIsValid }
    private var ⓤnitDescription: String { 📱.ⓜassUnit?.description ?? "kg" }
    var body: some View {
        Section {
            VStack {
                Text(📱.ⓜassInputDescription + self.ⓤnitDescription)
                    .font(.system(.title3, design: .rounded, weight: .heavy))
                    .monospacedDigit()
                    .minimumScaleFactor(0.5)
                    .opacity(self.ⓘnputIsValid ? 1 : 0.2)
                    .lineLimit(1)
                Stepper {
                    📉DifferenceView(.bodyMass)
                } onIncrement: {
                    📱.🎚️changeMassValue(.increment)
                } onDecrement: {
                    📱.🎚️changeMassValue(.decrement)
                }
                .disabled(!self.ⓘnputIsValid)
                .focusable(false)
            }
        } header: {
            Text("Body Mass")
                .bold()
        }
        .animation(.default, value: self.ⓘnputIsValid)
        .animation(.default, value: 📱.ⓓifference[.bodyMass] == nil)
    }
}

struct 🎚️BodyFatStepper: View {
    @EnvironmentObject var 📱: 📱AppModel
    private var ⓘnputIsValid: Bool { 📱.ⓑodyFatInputIsValid }
    var body: some View {
        if 📱.🚩ableBodyFat {
            Section {
                VStack {
                    Text(📱.ⓑodyFatInputDescription + "%")
                        .font(.system(.title3, design: .rounded, weight: .heavy))
                        .monospacedDigit()
                        .minimumScaleFactor(0.5)
                        .opacity(self.ⓘnputIsValid ? 1 : 0.2)
                        .lineLimit(1)
                    Stepper {
                        📉DifferenceView(.bodyFatPercentage)
                    } onIncrement: {
                        📱.🎚️changeBodyFatValue(.increment)
                    } onDecrement: {
                        📱.🎚️changeBodyFatValue(.decrement)
                    }
                    .disabled(!self.ⓘnputIsValid)
                    .focusable(false)
                }
            } header: {
                Text("Body Fat Percentage")
                    .bold()
            }
            .animation(.default, value: self.ⓘnputIsValid)
            .animation(.default, value: 📱.ⓓifference[.bodyFatPercentage] == nil)
        }
    }
}

struct 🪧BMIView: View {
    @EnvironmentObject var 📱: 📱AppModel
    private var ⓘnputValue: Double? { 📱.ⓑmiInputValue }
    private var ⓗeightQuantityDescription: String? { 📱.ⓗeightQuantityDescription }
    var body: some View {
        if 📱.🚩ableBMI {
            Section {
                if let ⓘnputValue, let ⓗeightQuantityDescription {
                    HStack {
                        VStack(alignment: .leading, spacing: 0) {
                            Text(ⓘnputValue.description)
                                .font(.system(.subheadline, design: .rounded, weight: .bold))
                                .monospacedDigit()
                            Text("(\(ⓗeightQuantityDescription))")
                                .font(.system(.caption2, design: .rounded, weight: .bold))
                                .foregroundStyle(.secondary)
                        }
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        Spacer()
                        📉DifferenceView(.bodyMassIndex, alignment: .trailing)
                    }
                } else {
                    Text("Height data is nothing on \"Health\" app. Register height data.")
                        .font(.footnote)
                        .foregroundStyle(.tertiary)
                }
            } header: {
                Text("Body Mass Index")
                    .bold()
            }
            .animation(.default, value: self.ⓘnputValue == nil)
            .animation(.default, value: 📱.ⓓifference[.bodyMassIndex] == nil)
        }
    }
}

struct 🪧LBMView: View {
    @EnvironmentObject var 📱: 📱AppModel
    private var ⓘnputDescription: String? { 📱.ⓛbmInputDescription }
    var body: some View {
        if 📱.🚩ableLBM {
            Section {
                HStack {
                    Text(ⓘnputDescription ?? "Error")
                        .font(.system(.subheadline, design: .rounded, weight: .bold))
                        .monospacedDigit()
                        .minimumScaleFactor(0.5)
                    Spacer()
                    📉DifferenceView(.leanBodyMass, alignment: .trailing)
                }
            } header: {
                Text("Lean Body Mass")
                    .bold()
            }
            .animation(.default, value: self.ⓘnputDescription == nil)
            .animation(.default, value: 📱.ⓓifference[.leanBodyMass] == nil)
        }
    }
}

struct 📉DifferenceView: View {
    @EnvironmentObject var 📱: 📱AppModel
    private var ⓐlignment: HorizontalAlignment
    private var ⓒategory: 🏥Category
    private var ⓓifference: 🄳ifference? { 📱.ⓓifference[self.ⓒategory] }
    var body: some View {
        if let ⓓifference {
            VStack(alignment: self.ⓐlignment, spacing: 0) {
                Text(ⓓifference.valueDescription)
                Text(ⓓifference.lastSampleDate, style: .offset)
            }
            .font(.caption2.monospaced())
            .foregroundStyle(.secondary)
            .minimumScaleFactor(0.1)
            .lineLimit(1)
            .dynamicTypeSize(..<DynamicTypeSize.small)
        }
    }
    init(_ ⓒategory: 🏥Category, alignment ⓐlignment: HorizontalAlignment = .center) {
        self.ⓒategory = ⓒategory
        self.ⓐlignment = ⓐlignment
    }
}

struct 🚨RegistrationErrorAlert: ViewModifier {
    @EnvironmentObject var 📱: 📱AppModel
    func body(content: Content) -> some View {
        content
            .alert("⚠️ Failed registration", isPresented: $📱.🚩alertRegistrationError) {
                EmptyView()
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

struct 🗯ResultView: View {
    @EnvironmentObject var 📱: 📱AppModel
    @State private var ⓢhowUndoAlert: Bool = false
    private var ⓒanceled: Bool { 📱.🚩completedCancellation }
    var body: some View {
        VStack {
            Spacer()
            Image(systemName: "checkmark")
                .font(.largeTitle.bold())
            Text("DONE!")
                .strikethrough(self.ⓒanceled)
                .font(.title.bold())
            Spacer()
            Text(📱.ⓡesultSummaryDescription)
                .strikethrough(self.ⓒanceled)
                .font(.body.bold())
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .minimumScaleFactor(0.1)
            if 📱.🚩ableDatePicker {
                if let ⓓate = 📱.📨registeredSamples.first?.startDate as? Date {
                    Text(ⓓate.formatted(date: .abbreviated, time: .shortened))
                        .strikethrough(self.ⓒanceled)
                        .font(.subheadline.weight(.semibold))
                        .padding(.horizontal)
                }
            }
            Spacer()
        }
        .opacity(self.ⓒanceled ? 0.25 : 1)
        .overlay(alignment: .bottom) {
            if self.ⓒanceled  {
                VStack {
                    Text("Canceled")
                        .fontWeight(.semibold)
                    if 📱.🚩alertCancellationError {
                        Text("(perhaps error)")
                    }
                }
            }
        }
        .onTapGesture {
            if !self.ⓒanceled  {
                self.ⓢhowUndoAlert = true
            }
        }
        .confirmationDialog("Undo?", isPresented: self.$ⓢhowUndoAlert) {
            Button("Yes, undo") {
                📱.🗑cancel()
            }
        }
        .modifier(🚨CancellationErrorAlert())
        .toolbar(.hidden, for: .automatic)
        //Digital Crown 押し込みでsheetを閉じれる
    }
}
