import SwiftUI
import HealthKit

struct 🗯ResultView: View {
    @EnvironmentObject var 📱: 📱AppModel
    private var ⓢuccess: Bool { 📱.🚨registerationError == nil }
    private var ⓕailed: Bool { !self.ⓢuccess }
    private var ⓒanceled: Bool { 📱.🚩canceled }
    private var ⓒancelError: Bool { 📱.🚨cancelError }
    var body: some View {
        NavigationView {
            ZStack {
                Rectangle()
                    .foregroundColor(self.ⓢuccess ? .pink : .gray)
                    .ignoresSafeArea()
                VStack {
                    VStack(spacing: 16) {
                        Image(systemName: self.ⓢuccess ? "checkmark" : "exclamationmark.triangle")
                            .font(.system(size: 96).weight(.semibold))
                        Text(self.ⓢuccess ? "DONE!" : "ERROR!?")
                            .strikethrough(self.ⓒanceled)
                            .font(.system(size: 96).weight(.black))
                        if self.ⓢuccess {
                            Text("Registration for \"Health\" app")
                                .strikethrough(self.ⓒanceled)
                                .font(.title3.weight(.semibold))
                        } else {
                            Text("Please check permission on \"Health\" app")
                                .font(.title3.weight(.semibold))
                        }
                        if self.ⓢuccess { self.🗯SummaryText() }
                        VStack {
                            self.💟jumpButton()
                            if self.ⓕailed {
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
                    .opacity(self.ⓒanceled ? 0.5 : 1)
                    .overlay(alignment: .topTrailing) {
                        if self.ⓒanceled {
                            VStack(alignment: .trailing) {
                                Text("Canceled")
                                    .fontWeight(.semibold)
                                if self.ⓒancelError {
                                    Text("(perhaps error)")
                                }
                            }
                            .padding(.trailing)
                            .padding(.top, 4)
                        }
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                .animation(.default, value: self.ⓒanceled)
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
        ToolbarItem(placement: .navigationBarTrailing) {
            if self.ⓢuccess {
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
}
