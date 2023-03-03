import SwiftUI
import HealthKit

struct 🗯ResultView: View {
    @EnvironmentObject var 📱: 📱AppModel
    @Environment(\.scenePhase) var scenePhase
    private var ⓒanceled: Bool { 📱.🚩canceled }
    private var ⓒancelError: Bool { 📱.🚨cancelError }
    var body: some View {
        NavigationView {
            ZStack {
                Rectangle()
                    .foregroundColor(.pink)
                    .ignoresSafeArea()
                VStack {
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
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .opacity(self.ⓒanceled ? 0.5 : 1)
                }
                .navigationBarTitleDisplayMode(.inline)
                .animation(.default, value: self.ⓒanceled)
                .toolbar {
                    self.🅧closeButton()
                    self.🗑cancelButton()
                    self.💟jumpButton()
                }
                .overlay(alignment: .bottom) {
                    if self.ⓒanceled {
                        VStack {
                            Text("Canceled")
                                .fontWeight(.semibold)
                            if self.ⓒancelError { Text("(perhaps error)") }
                        }
                    }
                }
            }
        }
        .preferredColorScheme(.dark)
        .onChange(of: self.scenePhase) {
            if $0 == .background { 📱.ⓡesetAppState() }
        }
    }
    private func 💟jumpButton() -> some ToolbarContent {
        ToolbarItem {
            💟JumpButton()
                .font(.title)
                .foregroundColor(.primary)
        }
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
    private func 🅧closeButton() -> some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button {
                📱.ⓡesetAppState()
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .symbolRenderingMode(.hierarchical)
                    .foregroundColor(.primary)
                    .font(.title)
            }
            .accessibilityLabel("Dismiss")
        }
    }
    private func 🗑cancelButton() -> some ToolbarContent {
        ToolbarItem(placement: .bottomBar) {
            Button {
                📱.🗑cancel()
            } label: {
                Image(systemName: "arrow.uturn.backward.circle.fill")
                    .symbolRenderingMode(.hierarchical)
                    .foregroundColor(.primary)
                    .font(.title2)
            }
            .disabled(self.ⓒanceled)
            .opacity(self.ⓒanceled ? 0.5 : 1)
            .accessibilityLabel("Cancel")
        }
    }
}
