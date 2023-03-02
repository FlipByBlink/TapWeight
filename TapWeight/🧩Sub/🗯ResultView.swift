import SwiftUI
import HealthKit

struct 🗯ResultView: View {
    @EnvironmentObject var 📱: 📱AppModel
    var body: some View {
        NavigationView {
            ZStack {
                Rectangle()
                    .foregroundColor(📱.🚨registerError ? .gray : .pink)
                    .ignoresSafeArea()
                VStack {
                    VStack(spacing: 16) {
                        Image(systemName: 📱.🚨registerError ? "exclamationmark.triangle" : "checkmark")
                            .font(.system(size: 96).weight(.semibold))
                        Text(📱.🚨registerError ? "ERROR!?" : "DONE!")
                            .strikethrough(📱.🚩canceled)
                            .font(.system(size: 96).weight(.black))
                        if 📱.🚨registerError {
                            Text("Please check permission on \"Health\" app")
                                .font(.title3.weight(.semibold))
                        } else {
                            Text("Registration for \"Health\" app")
                                .strikethrough(📱.🚩canceled)
                                .font(.title3.weight(.semibold))
                        }
                        if 📱.🚨registerError == false {
                            self.🗯SummaryText()
                        }
                        VStack {
                            self.💟jumpButton()
                            if 📱.🚨registerError {
                                Image(systemName: "arrow.up")
                                    .imageScale(.small)
                                    .font(.title)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                    .lineLimit(1)
                    .minimumScaleFactor(0.3)
                    .padding()
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .opacity(📱.🚩canceled ? 0.5 : 1)
                    .overlay(alignment: .topTrailing) {
                        if 📱.🚩canceled {
                            VStack(alignment: .trailing) {
                                Text("Canceled")
                                    .fontWeight(.semibold)
                                if 📱.🚨cancelError {
                                    Text("(perhaps error)")
                                }
                            }
                            .padding(.trailing)
                            .padding(.top, 4)
                        }
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                .animation(.default, value: 📱.🚩canceled)
                .toolbar {
                    self.🅧closeButton()
                    self.🗑cancelButton()
                }
            }
        }
        .preferredColorScheme(.dark)
    }
    private func 💟jumpButton() -> some View {
        Link(destination: URL(string: "x-apple-health://")!) {
            Image(systemName: "app")
                .imageScale(.large)
                .overlay {
                    Image(systemName: "heart")
                        .imageScale(.small)
                }
                .foregroundColor(.primary)
                .padding(24)
                .font(.system(size: 32))
        }
        .accessibilityLabel("Open \"Health\" app")
    }
    private func 🗯SummaryText() -> some View {
        Group {
            Text(📱.ⓡesultSummaryDescription ?? "🐛")
                .strikethrough(📱.🚩canceled)
                .font(.body.bold())
            if 📱.🚩ableDatePicker {
                if let ⓓate = 📱.📨registeredSamples.first?.startDate as? Date {
                    Text(ⓓate.formatted(date: .abbreviated, time: .shortened))
                        .strikethrough(📱.🚩canceled)
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
        ToolbarItem(placement: .navigationBarTrailing) {
            if 📱.🚨registerError == false {
                Button {
                    📱.🗑cancel()
                } label: {
                    Image(systemName: "arrow.uturn.backward.circle.fill")
                        .symbolRenderingMode(.hierarchical)
                        .foregroundColor(.primary)
                        .font(.title)
                }
                .disabled(📱.🚩canceled)
                .opacity(📱.🚩canceled ? 0.5 : 1)
                .accessibilityLabel("Cancel")
            }
        }
    }
}
