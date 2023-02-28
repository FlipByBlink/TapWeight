import SwiftUI
import HealthKit

struct 🗯ResultView: View {
    @EnvironmentObject var 📱: 📱AppModel
    @Environment(\.dismiss) var dismiss
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
                            🗯SummaryView()
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
                .onDisappear { 📱.ⓡeset() }
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
    private func 🅧closeButton() -> some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button {
                self.dismiss()
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

struct 🗯SummaryView: View {
    @EnvironmentObject var 📱: 📱AppModel
    private var 🪧description: String {
        return 📱.📨cacheSamples.reduce("") { ⓓescription, ⓢample in
            switch ⓢample.quantityType {
                case .init(.bodyMass):
                    guard let ⓤnit = 📱.📦units[.bodyMass] else { return "🐛" }
                    let ⓥalue = ⓢample.quantity.doubleValue(for: ⓤnit)
                    return ⓓescription + ⓥalue.description + " " + ⓤnit.description
                case .init(.bodyMassIndex):
                    return ⓓescription +  " / " + ⓢample.quantity.doubleValue(for: .count()).description
                case .init(.bodyFatPercentage):
                    let ⓥalue = round(ⓢample.quantity.doubleValue(for: .percent())*1000)/10
                    return ⓓescription +  " / " + ⓥalue.description + " %"
                default: return ⓓescription
            }
        }
    }
    var body: some View {
        Group {
            Text(self.🪧description)
                .strikethrough(📱.🚩canceled)
                .font(.body.bold())
            if 📱.🚩ableDatePicker {
                if let ⓓate = 📱.📨cacheSamples.first?.startDate as? Date {
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
}

//ADMenuSheetを表示したままアプリをバックグラウンドに移行した際に、ResultViewの自動非表示機能がうまく動作しない。
//そのためADBanner上のADMenuシートを削除。
