import SwiftUI

struct 🚨ErrorMessage: View {
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
    private var ⓐppIsInvalid: Bool { !self.ⓘnvalidSampleCategories.isEmpty }
    var body: some View {
        if self.ⓐppIsInvalid {
            VStack(spacing: 4) {
                Text("⚠️ Error")
                    .font(.headline)
                Text("Please launch iPhone app to sync. If registered data is nothing, register your data to \"Health\". Or check authentication on Apple Watch.")
                    .font(.caption2)
                VStack(alignment: .leading) {
                    ForEach(self.ⓘnvalidSampleCategories, id: \.identifier) {
                        Text("・" + $0.localizedString)
                    }
                }
                .font(.caption2.weight(.semibold))
            }
            .foregroundStyle(.secondary)
            .padding(.vertical, 8)
        }
    }
}

struct 🔐AuthManager: ViewModifier {
    @EnvironmentObject var 📱: 📱AppModel
    func body(content: Content) -> some View {
        content
            .onAppear { 📱.ⓡequestAuths() }
            .onChange(of: [📱.🚩ableBMI, 📱.🚩ableBodyFat, 📱.🚩ableLBM]) { _ in
                📱.ⓡequestAuths()
            }
    }
}

struct 🎚️BodyMassStepper: View {
    @EnvironmentObject var 📱: 📱AppModel
    private var ⓘnputIsInvalid: Bool { 📱.📝massInputQuantity == nil }
    private var ⓤnitDescription: String { 📱.ⓜassUnitDescription ?? "kg" }
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
                    .opacity(self.ⓘnputIsInvalid ? 0.5 : 1)
                    .animation(.default.speed(2), value: self.ⓘnputIsInvalid)
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
    }
}

struct 🎚️BodyFatStepper: View {
    @EnvironmentObject var 📱: 📱AppModel
    private var ⓘnputIsInvalid: Bool { 📱.📝bodyFatInputQuantity == nil }
    var body: some View {
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
                    .opacity(self.ⓘnputIsInvalid ? 0.5 : 1)
                    .animation(.default.speed(2), value: self.ⓘnputIsInvalid)
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
    }
}

struct 🪧BMIView: View {
    @EnvironmentObject var 📱: 📱AppModel
    private var ⓘnputValue: Double? { 📱.ⓑmiInputValue }
    private var ⓗeightQuantityDescription: String? { 📱.ⓗeightQuantityDescription }
    var body: some View {
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

struct 🪧LBMView: View {
    @EnvironmentObject var 📱: 📱AppModel
    private var ⓘnputDescription: String? { 📱.ⓛbmInputDescription }
    var body: some View {
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

struct 👆RegisterButton: View { // ☑️
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
        .modifier(🚨RegistrationErrorAlert())
        .fullScreenCover(isPresented: $📱.🚩showResult) { 🗯ResultView() }
        .onChange(of: 📱.🚩showResult) {
            if $0 == false { 📱.ⓒlearStates() }
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
                .font(.title.bold())
            Spacer()
            Text(📱.ⓡesultSummaryDescription)
                .font(.body.bold())
                .lineLimit(2)
                .multilineTextAlignment(.center)
            Spacer()
        }
        .minimumScaleFactor(0.1)
        .padding(.horizontal)
        .strikethrough(self.ⓒanceled)
        .opacity(self.ⓒanceled ? 0.25 : 1)
        .overlay(alignment: .bottom) {
            if self.ⓒanceled {
                Text("Canceled")
                    .fontWeight(.semibold)
            }
        }
        .onTapGesture {
            if !self.ⓒanceled { self.ⓢhowUndoAlert = true }
        }
        .confirmationDialog("Undo?", isPresented: self.$ⓢhowUndoAlert) {
            Button("Yes, undo") { 📱.🗑cancel() }
        }
        .modifier(🚨CancellationErrorAlert())
        .toolbar(.hidden, for: .automatic)
    }
    //Dismiss by pushing DigitalCrown
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
