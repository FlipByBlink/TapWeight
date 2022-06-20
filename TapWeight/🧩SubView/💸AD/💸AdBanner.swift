
import SwiftUI

struct 💸ADBanner: View {
    @EnvironmentObject var 📱:📱Model
    @EnvironmentObject var 🏬: 🏬Store
    
    @State private var 🚩ShowBanner = false
    
    @AppStorage("🄻aunchCount") var 🄻aunchCount: Int = 0
    
    var 🅃iming: Int = 2 // 7
    
    var body: some View {
        Group {
            if 🏬.🚩Purchased || 📱.🚨RegisterError {
                Spacer()
            } else {
                if 🚩ShowBanner {
                    💸ADView()
                        .padding(.horizontal)
                        .overlay(alignment: .topLeading) {
                            Button {
                                🚩ShowBanner = false
                            } label: {
                                Image(systemName: "xmark.circle")
                                    .padding(8)
                            }
                            .foregroundStyle(.tertiary)
                        }
                        .overlay(alignment: .bottomLeading) {
                            Text("AD")
                                .scaleEffect(x: 1.2)
                                .font(.subheadline.weight(.black))
                                .padding(.leading)
                                .padding(.bottom, 5)
                                .foregroundStyle(.quaternary)
                        }
                        .background {
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .foregroundStyle(.background)
                                .shadow(radius: 3)
                        }
                        .padding()
                        .environment(\.colorScheme, .light)
                } else {
                    Spacer()
                }
            }
        }
        .onAppear {
            🄻aunchCount += 1
            if 🄻aunchCount % 🅃iming == 0 {
                🚩ShowBanner = true
            }
        }
    }
}
