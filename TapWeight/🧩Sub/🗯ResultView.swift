
import SwiftUI
import HealthKit

struct 🗯ResultView: View {
    @EnvironmentObject var 📱: 📱AppModel
    @Environment(\.dismiss) var 🔙Dismiss: DismissAction
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
                            💟JumpButton()
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
                    
                    📣ADBanner()
                }
                .onDisappear { 📱.ⓡeset() }
                .navigationBarTitleDisplayMode(.inline)
                .animation(.default, value: 📱.🚩canceled)
                .toolbar {
                    🅧CloseButton()
                    🗑CancelButton()
                }
            }
        }
        .preferredColorScheme(.dark)
    }
    
    func 💟JumpButton() -> some View {
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
    
    func 🅧CloseButton() -> some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button {
                🔙Dismiss.callAsFunction()
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
    
    func 🗑CancelButton() -> some ToolbarContent {
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
    var 🪧Description: String {
        return 📱.📦samples.reduce("") { 🪧, ⓢample in
            switch ⓢample.quantityType {
                case .init(.bodyMass):
                    let ⓥalue = ⓢample.quantity.doubleValue(for: 📱.📏massUnit.hkunit)
                    return 🪧 + ⓥalue.description + " " + 📱.📏massUnit.rawValue
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
                .strikethrough(📱.🚩canceled)
                .font(.body.bold())
            if 📱.🚩ableDatePicker {
                if let 📦Date = 📱.📦samples.first?.startDate as? Date {
                    Text(📦Date.formatted(date: .abbreviated, time: .shortened))
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

struct 📣ADBanner: View {
    @EnvironmentObject var 📱: 📱AppModel
    @EnvironmentObject var 🛒: 🛒StoreModel
    @State private var 🚩ShowBanner = false
    @AppStorage("🄻aunchCount") var 🄻aunchCount: Int = 0
    
    var body: some View {
        Group {
            if 🛒.🚩Purchased || 📱.🚨registerError {
                Spacer()
            } else {
                if 🚩ShowBanner {
                    📣ADView(without: .TapWeight)
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
//ADMenuSheetを表示したままアプリをバックグラウンドに移行した際に、ResultViewの自動非表示機能がうまく動作しない。
//そのためADBanner上のADMenuシートを削除。
