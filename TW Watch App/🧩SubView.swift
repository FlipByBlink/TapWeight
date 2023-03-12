import SwiftUI

struct 🚨CheckCondition: ViewModifier {
    @EnvironmentObject var 📱: 📱AppModel
    @State private var 🚩finishedFirstQuary: Bool = false
    private var ⓘnvalidCategories: [🏥Category] {
        var ⓡesult: [🏥Category] = []
        if 📱.📦latestSamples[.bodyMass] == nil {
            ⓡesult += [.bodyMass]
        }
        if 📱.🚩ableBMI {
            if 📱.📦latestSamples[.height] == nil {
                ⓡesult += [.height]
            }
        }
        if 📱.🚩ableBodyFat && (📱.📦latestSamples[.bodyFatPercentage] == nil) {
            ⓡesult += [.bodyFatPercentage]
        }
        return ⓡesult
    }
    private var ⓘnputInvalid: Bool { !self.ⓘnvalidCategories.isEmpty }
    func body(content: Content) -> some View {
        Group {
            if self.🚩finishedFirstQuary && self.ⓘnputInvalid {
                self.ⓔrrorView()
            } else {
                content
            }
        }
        .animation(.default, value: self.🚩finishedFirstQuary && self.ⓘnputInvalid)
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
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    private var ⓘnputIsValid: Bool { 📱.ⓜassInputIsValid }
    private var ⓤnitDescription: String { 📱.ⓜassUnit?.description ?? "kg" }
    private var ⓜultilineLayout: Bool { self.dynamicTypeSize > .xLarge }
    var body: some View {
        Section {
            VStack {
                Stepper {
                    Text(📱.ⓜassInputDescription + (self.ⓜultilineLayout ? "\n" : "") + self.ⓤnitDescription)
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .monospacedDigit()
                        .minimumScaleFactor(0.5)
                        .multilineTextAlignment(.center)
                        .opacity(self.ⓘnputIsValid ? 1 : 0.2)
                        .animation(.default, value: self.ⓘnputIsValid)
                } onIncrement: {
                    📱.🎚️changeMassValue(.increment)
                } onDecrement: {
                    📱.🎚️changeMassValue(.decrement)
                }
                .disabled(!self.ⓘnputIsValid)
                .focusable(false)
                📉DifferenceView(.bodyMass)
            }
            .lineLimit(self.ⓜultilineLayout ? 2 : 1)
        } header: {
            Text("Body Mass")
                .bold()
        }
    }
}

struct 🎚️BodyFatStepper: View {
    @EnvironmentObject var 📱: 📱AppModel
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    private var ⓘnputIsValid: Bool { 📱.ⓑodyFatInputIsValid }
    private var ⓜultilineLayout: Bool { self.dynamicTypeSize > .xLarge }
    var body: some View {
        if 📱.🚩ableBodyFat {
            Section {
                VStack {
                    Stepper {
                        Text(📱.ⓑodyFatInputDescription + (self.ⓜultilineLayout ? "\n" : "") + "%")
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .monospacedDigit()
                            .opacity(self.ⓘnputIsValid ? 1 : 0.2)
                            .minimumScaleFactor(0.5)
                            .multilineTextAlignment(.center)
                    } onIncrement: {
                        📱.🎚️changeBodyFatValue(.increment)
                    } onDecrement: {
                        📱.🎚️changeBodyFatValue(.decrement)
                    }
                    .disabled(!self.ⓘnputIsValid)
                    .focusable(false)
                    .lineLimit(self.ⓜultilineLayout ? 2 : 1)
                    .animation(.default, value: self.ⓘnputIsValid)
                    📉DifferenceView(.bodyFatPercentage)
                }
            } header: {
                Text("Body Fat Percentage")
                    .bold()
            }
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
                    VStack {
                        HStack(alignment: .firstTextBaseline) {
                            Text(ⓘnputValue.description)
                                .font(.system(size: 16, weight: .bold, design: .rounded))
                                .monospacedDigit()
                            Text("(\(ⓗeightQuantityDescription))")
                                .font(.system(size: 12, weight: .bold, design: .rounded))
                                .foregroundStyle(.secondary)
                        }
                        📉DifferenceView(.bodyMassIndex)
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
        }
    }
}

struct 🪧LBMView: View {
    @EnvironmentObject var 📱: 📱AppModel
    private var ⓘnputDescription: String? { 📱.ⓛbmInputDescription }
    var body: some View {
        if 📱.🚩ableLBM {
            Section {
                VStack {
                    Text(ⓘnputDescription ?? "Error")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .monospacedDigit()
                    📉DifferenceView(.leanBodyMass)
                }
            } header: {
                Text("Lean Body Mass")
                    .bold()
            }
        }
    }
}

struct 📉DifferenceView: View {
    @EnvironmentObject var 📱: 📱AppModel
    private var ⓒategory: 🏥Category
    private var ⓓifference: 🄳ifference? { 📱.ⓓifference[self.ⓒategory] }
    var body: some View {
        if let ⓓifference {
            LabeledContent(ⓓifference.valueDescription) {
                Text(ⓓifference.lastSampleDate, style: .offset)
            }
            .padding(.horizontal)
            .font(.caption2.monospaced())
            .foregroundStyle(.secondary)
            .minimumScaleFactor(0.1)
            .lineLimit(1)
        }
    }
    init(_ ⓒategory: 🏥Category) {
        self.ⓒategory = ⓒategory
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
