
import SwiftUI
import HealthKit

struct 🗯ResultView: View {
    @EnvironmentObject var 📱: 📱AppModel
    @Environment(\.dismiss) var 🔙Dismiss: DismissAction
    var body: some View {
        NavigationView {
            ZStack {
                Rectangle()
                    .foregroundColor(📱.🚨RegisterError ? .gray : .pink)
                    .ignoresSafeArea()
                VStack {
                    VStack(spacing: 16) {
                        Image(systemName: 📱.🚨RegisterError ? "exclamationmark.triangle" : "checkmark")
                            .font(.system(size: 96).weight(.semibold))
                        Text(📱.🚨RegisterError ? "ERROR!?" : "DONE!")
                            .strikethrough(📱.🚩Canceled)
                            .font(.system(size: 96).weight(.black))
                        if 📱.🚨RegisterError {
                            Text("Please check permission on \"Health\" app")
                                .font(.title3.weight(.semibold))
                        } else {
                            Text("Registration for \"Health\" app")
                                .strikethrough(📱.🚩Canceled)
                                .font(.title3.weight(.semibold))
                        }
                        
                        if 📱.🚨RegisterError == false {
                            🗯SummaryView()
                        }
                        
                        VStack {
                            💟JumpButton()
                            if 📱.🚨RegisterError {
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
                    .opacity(📱.🚩Canceled ? 0.5 : 1)
                    .overlay(alignment: .topTrailing) {
                        if 📱.🚩Canceled {
                            VStack(alignment: .trailing) {
                                Text("Canceled")
                                    .fontWeight(.semibold)
                                if 📱.🚨CancelError {
                                    Text("(perhaps error)")
                                }
                            }
                            .padding(.trailing)
                            .padding(.top, 4)
                        }
                    }
                    
                    📣ADBanner()
                }
                .onDisappear { 📱.🅁eset() }
                .navigationBarTitleDisplayMode(.inline)
                .animation(.default, value: 📱.🚩Canceled)
                .toolbar {
                    🅧CloseButton {
                        🔙Dismiss.callAsFunction()
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        if 📱.🚨RegisterError == false {
                            Button {
                                Task {
                                    await 📱.🗑Cancel()
                                }
                            } label: {
                                Image(systemName: "arrow.uturn.backward.circle.fill")
                                    .symbolRenderingMode(.hierarchical)
                                    .foregroundColor(.primary)
                                    .font(.title)
                            }
                            .disabled(📱.🚩Canceled)
                            .opacity(📱.🚩Canceled ? 0.5 : 1)
                            .accessibilityLabel("Cancel")
                        }
                    }
                }
            }
        }
        .preferredColorScheme(.dark)
    }
    
    struct 💟JumpButton: View {
        var body: some View {
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
    }
    
    struct 🅧CloseButton: ToolbarContent {
        var ⓐction: () -> Void
        var body: some ToolbarContent {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    ⓐction()
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
    }
}

struct 🗯SummaryView: View {
    @EnvironmentObject var 📱: 📱AppModel
    var 🪧Description: String {
        return 📱.📦Samples.reduce("") { 🪧, ⓢample in
            switch ⓢample.quantityType {
                case .init(.bodyMass):
                    let ⓥalue = ⓢample.quantity.doubleValue(for: 📱.📏MassUnit.hkunit)
                    return 🪧 + ⓥalue.description + " " + 📱.📏MassUnit.rawValue
                case .init(.bodyMassIndex):
                    return 🪧 +  " / " + ⓢample.quantity.doubleValue(for: .count()).description
                case .init(.bodyFatPercentage):
                    let ⓥalue = round(ⓢample.quantity.doubleValue(for: .percent())*1000)/10
                    return 🪧 +  " / " + ⓥalue.description + " %"
                default: return 🪧
            }
        }
    }
    
    var body: some View {
        Group {
            Text(🪧Description)
                .strikethrough(📱.🚩Canceled)
                .font(.body.bold())
            if 📱.🚩AbleDatePicker {
                if let 📦Date = 📱.📦Samples.first?.startDate as? Date {
                    Text(📦Date.formatted(date: .abbreviated, time: .shortened))
                        .strikethrough(📱.🚩Canceled)
                        .font(.subheadline.weight(.semibold))
                        .padding(.horizontal)
                }
            }
        }
        .opacity(0.75)
        .padding(.horizontal, 42)
    }
}

struct 📣ADBanner: View {
    @EnvironmentObject var 📱: 📱AppModel
    @EnvironmentObject var 🛒: 🛒StoreModel
    @State private var 🚩ShowBanner = false
    @AppStorage("🄻aunchCount") var 🄻aunchCount: Int = 0
    
    var body: some View {
        Group {
            if 🛒.🚩Purchased || 📱.🚨RegisterError {
                Spacer()
            } else {
                if 🚩ShowBanner {
                    📣ADView()
                        .padding(.horizontal)
                        .background {
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .foregroundStyle(.background)
                                .shadow(radius: 3)
                        }
                        .padding()
                        .frame(maxHeight: 180)
                        .environment(\.colorScheme, .light)
                } else {
                    Spacer()
                }
            }
        }
        .onAppear {
            🄻aunchCount += 1
            if 🄻aunchCount > 5 { 🚩ShowBanner = true }
        }
    }
}
