import SwiftUI

struct 🚨CheckCondition: ViewModifier {
    @EnvironmentObject var 📱: 📱AppModel
    private var ⓘnvalidSampleCategories: [🏥Category] {
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
    private var ⓐppIsValid: Bool { self.ⓘnvalidSampleCategories.isEmpty }
    func body(content: Content) -> some View {
        if self.ⓐppIsValid {
            content
        } else {
            self.ⓔrrorView()
        }
    }
    private func ⓔrrorView() -> some View {
        ScrollView {
            Text("Error")
                .font(.headline)
            Text("Did not find the recent data. Please register your data on the iPhone first. Or check authentication on Apple Watch.")
            ForEach(self.ⓘnvalidSampleCategories, id: \.identifier) { ⓒategory in
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
        .fullScreenCover(isPresented: $📱.🚩showResult) { 🗯ResultView() }
    }
}

struct 🎚️BodyMassStepper: View {
    @EnvironmentObject var 📱: 📱AppModel
    private var ⓘnputIsValid: Bool { 📱.ⓜassInputIsValid }
    private var ⓤnitDescription: String { 📱.ⓜassUnit?.description ?? "kg" }
    var body: some View {
        HStack {
            Button {
                📱.🎚️changeMassValue(.decrement)
            } label: {
                Image(systemName: "minus.circle.fill")
                    .symbolRenderingMode(.hierarchical)
                    .font(.title2)
                    .imageScale(.small)
            }
            .buttonStyle(.plain)
            Spacer()
            HStack(alignment: .firstTextBaseline, spacing: 2) {
                Text(📱.ⓜassInputDescription)
                    .font(.system(.title2, design: .rounded, weight: .heavy))
                Text(self.ⓤnitDescription)
                    .font(.system(.title3, design: .rounded, weight: .heavy))
                    .dynamicTypeSize(..<DynamicTypeSize.medium)
            }
            Spacer()
            Button {
                📱.🎚️changeMassValue(.increment)
            } label: {
                Image(systemName: "plus.circle.fill")
                    .symbolRenderingMode(.hierarchical)
                    .font(.title2)
                    .imageScale(.small)
            }
            .buttonStyle(.plain)
        }
        .monospacedDigit()
        .minimumScaleFactor(0.5)
        .lineLimit(1)
        .opacity(self.ⓘnputIsValid ? 1 : 0.2)
        .disabled(!self.ⓘnputIsValid)
        .animation(.default, value: self.ⓘnputIsValid)
    }
}

struct 🎚️BodyFatStepper: View {
    @EnvironmentObject var 📱: 📱AppModel
    private var ⓘnputIsValid: Bool { 📱.ⓑodyFatInputIsValid }
    var body: some View {
        if 📱.🚩ableBodyFat {
            HStack {
                Button {
                    📱.🎚️changeBodyFatValue(.decrement)
                } label: {
                    Image(systemName: "minus.circle.fill")
                        .symbolRenderingMode(.hierarchical)
                        .font(.title2)
                        .imageScale(.small)
                }
                .buttonStyle(.plain)
                Spacer()
                HStack(alignment: .firstTextBaseline, spacing: 2) {
                    Text(📱.ⓑodyFatInputDescription)
                        .font(.system(.title2, design: .rounded, weight: .heavy))
                    Text("%")
                        .font(.system(.title3, design: .rounded, weight: .heavy))
                }
                Spacer()
                Button {
                    📱.🎚️changeBodyFatValue(.increment)
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .symbolRenderingMode(.hierarchical)
                        .font(.title2)
                        .imageScale(.small)
                }
                .buttonStyle(.plain)
            }
            .monospacedDigit()
            .minimumScaleFactor(0.5)
            .lineLimit(1)
            .opacity(self.ⓘnputIsValid ? 1 : 0.2)
            .disabled(!self.ⓘnputIsValid)
            .animation(.default, value: self.ⓘnputIsValid)
        }
    }
}

struct 🪧BMIView: View {
    @EnvironmentObject var 📱: 📱AppModel
    private var ⓘnputValue: Double? { 📱.ⓑmiInputValue }
    private var ⓗeightQuantityDescription: String? { 📱.ⓗeightQuantityDescription }
    var body: some View {
        if 📱.🚩ableBMI {
            VStack(alignment: .leading) {
                Text("Body Mass Index")
                    .font(.caption2.weight(.semibold))
                if let ⓘnputValue, let ⓗeightQuantityDescription {
                    HStack {
                        Text(ⓘnputValue.description)
                            .font(.subheadline.bold())
                            .monospacedDigit()
                        Spacer()
                        Text("(\(ⓗeightQuantityDescription))")
                            .font(.caption2.bold())
                            .foregroundStyle(.tertiary)
                    }
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                } else {
                    Text("Height data is nothing on \"Health\" app. Register height data.")
                        .font(.footnote)
                        .foregroundStyle(.tertiary)
                }
            }
            .foregroundStyle(.secondary)
            .animation(.default, value: self.ⓘnputValue == nil)
        }
    }
}

struct 🪧LBMView: View {
    @EnvironmentObject var 📱: 📱AppModel
    private var ⓘnputDescription: String? { 📱.ⓛbmInputDescription }
    var body: some View {
        if 📱.🚩ableLBM {
            VStack(alignment: .leading) {
                Text("Lean Body Mass")
                    .font(.caption2.weight(.semibold))
                Text(ⓘnputDescription ?? "Error")
                    .font(.subheadline.bold())
                    .monospacedDigit()
                    .minimumScaleFactor(0.5)
            }
            .foregroundStyle(.secondary)
            .animation(.default, value: self.ⓘnputDescription == nil)
        }
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

#if DEBUG
struct 🏥CheckEarliestPermittedSampleDateView: View {
    @EnvironmentObject var 📱: 📱AppModel
    var body: some View {
        Text(📱.🏥healthStore.api.earliestPermittedSampleDate(), style: .offset)
        //Almost 1 week ago on Apple Watch
    }
}
#endif
