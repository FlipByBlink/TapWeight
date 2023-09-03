import SwiftUI
import HealthKit

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
                        .lineLimit(1)
                    Text("Registration for \"Health\" app")
                        .strikethrough(self.ⓒanceled)
                        .font(.title3.weight(.semibold))
                        .lineLimit(1)
                    self.summaryText()
                        .lineLimit(2)
                }
                .minimumScaleFactor(0.3)
                .padding()
                .padding(.bottom, 120)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .opacity(self.ⓒanceled ? 0.5 : 1)
                .overlay(alignment: .bottom) {
                    if self.ⓒanceled {
                        Text("Canceled")
                            .font(.headline)
                    }
                }
                .toolbar {
                    self.closeButton()
                    self.cancelButton()
                    💟OpenHealthAppButton.onResultView()
                }
            }
            .animation(.default, value: self.ⓒanceled)
            .navigationBarTitleDisplayMode(.inline)
        }
        .preferredColorScheme(.dark)
        .modifier(🚨CancellationErrorAlert())
        .modifier(💬RequestUserReview())
    }
}

private extension 🗯ResultView {
    private func summaryText() -> some View {
        Group {
            Text(📱.ⓡesultSummaryDescription)
                .strikethrough(self.ⓒanceled)
                .font(.body.bold())
                .multilineTextAlignment(.center)
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
    private func closeButton() -> some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button {
                📱.ⓒloseResultView()
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
    private func cancelButton() -> some ToolbarContent {
        ToolbarItem(placement: .status) {
            Button {
                📱.🗑cancel()
            } label: {
                Image(systemName: "arrow.uturn.backward.circle.fill")
                    .symbolRenderingMode(.hierarchical)
                    .foregroundColor(.primary)
                    .font(.title)
            }
            .offset(y: -12)
            .disabled(self.ⓒanceled)
            .opacity(self.ⓒanceled ? 0.5 : 1)
            .accessibilityLabel("Cancel")
        }
    }
}
