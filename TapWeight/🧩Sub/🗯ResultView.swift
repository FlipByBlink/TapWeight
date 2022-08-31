
import SwiftUI

struct 🗯ResultView2: View {
    @EnvironmentObject var 📱: 📱AppModel
    @Environment(\.dismiss) var 🔙: DismissAction
    
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
                            let 🅂ummary: String = {
                                var 🪧 = ""
                                🪧 += 📱.📝MassValue.description + " " + 📱.📏MassUnit.rawValue
                                if 📱.🚩AbleBMI { 🪧 += " / " + 📱.📝BMIValue.description }
                                if 📱.🚩AbleBodyFat {
                                    🪧 += " / " + (round(📱.📝BodyFatValue*1000)/10).description + " %"
                                }
                                return 🪧
                            }()
                            
                            Group {
                                Text(🅂ummary)
                                    .strikethrough(📱.🚩Canceled)
                                    .font(.body.bold())
                                
                                if 📱.🚩AbleDatePicker {
                                    Text(📱.📅PickerValue.formatted(date: .abbreviated, time: .shortened))
                                        .strikethrough(📱.🚩Canceled)
                                        .font(.subheadline.weight(.semibold))
                                        .padding(.horizontal)
                                }
                            }
                            .opacity(0.75)
                            .padding(.horizontal, 42)
                        }
                        
                        VStack {
                            Link(destination: URL(string: "x-apple-health://")!) {
                                Image(systemName: "app")
                                    .imageScale(.large)
                                    .overlay {
                                        Image(systemName: "heart")
                                            .imageScale(.small)
                                    }
                                    .font(.title)
                                    .foregroundColor(.primary)
                                    .padding(12)
                            }
                            .accessibilityLabel("Open \"Health\" app")
                            
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
                .onDisappear {
                    📱.🅁eset()
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            🔙.callAsFunction()
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .symbolRenderingMode(.hierarchical)
                                .foregroundColor(.primary)
                                .font(.title)
                        }
                        .accessibilityLabel("Dismiss")
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
        .animation(.default, value: 📱.🚩Canceled)
    }
}

struct 🗯ResultView: View {
    @EnvironmentObject var 📱: 📱AppModel
    @Environment(\.dismiss) var 🔙: DismissAction
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(📱.🚨RegisterError ? .gray : .pink)
                .ignoresSafeArea()
            
            VStack {
                📣ADBanner()
                
                Button {
                    🔙.callAsFunction()
                } label: {
                    VStack(spacing: 16) {
                        Spacer()
                        
                        Image(systemName: 📱.🚨RegisterError ? "exclamationmark.triangle" : "checkmark")
                            .font(.system(size: 96).weight(.semibold))
                        
                        Text(📱.🚨RegisterError ? "ERROR!?" : "DONE!")
                            .font(.system(size: 96).weight(.black))
                        
                        if 📱.🚨RegisterError {
                            Text("Please check permission on \"Health\" app")
                                .font(.title3.weight(.semibold))
                        } else {
                            Text("Registration for \"Health\" app")
                                .font(.title3.weight(.semibold))
                        }
                        
                        Spacer()
                        
                        if 📱.🚨RegisterError == false {
                            let 🅂ummary: String = {
                                var 🪧 = ""
                                🪧 += 📱.📝MassValue.description + " " + 📱.📏MassUnit.rawValue
                                if 📱.🚩AbleBMI { 🪧 += " / " + 📱.📝BMIValue.description }
                                if 📱.🚩AbleBodyFat {
                                    🪧 += " / " + (round(📱.📝BodyFatValue*1000)/10).description + " %"
                                }
                                return 🪧
                            }()
                            
                            Group {
                                Text(🅂ummary)
                                    .font(.body.bold())
                                
                                if 📱.🚩AbleDatePicker {
                                    Label(📱.📅PickerValue.formatted(date: .abbreviated, time: .shortened), systemImage: "calendar")
                                        .font(.subheadline.weight(.semibold))
                                        .padding(.horizontal)
                                }
                            }
                            .opacity(0.75)
                            .padding(.horizontal, 42)
                        }
                        
                        Spacer()
                        
                        Color.clear
                            .frame(height: 72)
                    }
                    .lineLimit(1)
                    .minimumScaleFactor(0.3)
                    .padding()
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .opacity(📱.🚩Canceled ? 0.33 : 1)
                .accessibilityLabel("Dismiss")
            }
            .overlay(alignment: .bottomLeading) {
                if 📱.🚨RegisterError == false {
                    HStack {
                        Button {
                            Task {
                                await 📱.🗑Cancel()
                            }
                        } label: {
                            Image(systemName: "arrow.uturn.backward.circle")
                                .font(.largeTitle)
                                .imageScale(.large)
                                .foregroundColor(.primary)
                                .padding(24)
                        }
                        .disabled(📱.🚩Canceled)
                        .opacity(📱.🚩Canceled ? 0.5 : 1)
                        .accessibilityLabel("Cancel")
                        
                        
                        if 📱.🚩Canceled {
                            VStack {
                                Text("Canceled")
                                    .fontWeight(.semibold)
                                
                                if 📱.🚨CancelError {
                                    Text("(perhaps error)")
                                }
                            }
                            .offset(x: -24)
                        }
                    }
                    .opacity(0.75)
                }
            }
            .overlay(alignment: .bottomTrailing) {
                VStack {
                    if 📱.🚨RegisterError {
                        Image(systemName: "arrow.down")
                            .imageScale(.small)
                            .font(.largeTitle)
                            .foregroundStyle(.secondary)
                            .offset(y: 16)
                    }
                    
                    💟JumpButton()
                        .foregroundStyle(.primary)
                        .padding(22)
                }
                .opacity(0.75)
            }
        }
        .preferredColorScheme(.dark)
        .onDisappear {
            📱.🅁eset()
        }
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
