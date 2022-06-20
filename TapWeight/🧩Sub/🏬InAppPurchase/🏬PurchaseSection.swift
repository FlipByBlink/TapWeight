
import SwiftUI
import StoreKit

struct 🏬PurchaseSection: View {
    @EnvironmentObject var 🏬: 🏬StoreModel
    
    @State var 🚨ErrorTitle = ""
    @State var 🚨ShowError: Bool = false
    
    @State private var 🚩BuyingNow = false
    
    var body: some View {
        Section {
            HStack {
                Label(🏬.🎫Name, systemImage: 🏬.🚩Purchased ? "checkmark" : "questionmark")
                
                Spacer()
                
                Button(🏬.🎫Price) {
                    Task {
                        do {
                            🚩BuyingNow = true
                            try await 🏬.👆Purchase()
                        } catch 🚨StoreError.failedVerification {
                            🚨ErrorTitle = "Your purchase could not be verified by the App Store."
                            🚨ShowError = true
                        } catch {
                            print("Failed purchase for AD Free: \(error)")
                        }
                        🚩BuyingNow = false
                    }
                }
                .disabled(🚩BuyingNow)
                .disabled(🏬.🚩Purchased)
                .buttonStyle(.borderedProminent)
            }
            .padding(.vertical, 8)
            
            
            Button {
                Task {
                    try? await AppStore.sync()
                }
            } label: {
                Label("Restore Purchase", systemImage: "arrow.uturn.backward")
                    .font(.subheadline)
                    .foregroundStyle(🏬.🚩Purchased ? .secondary : .primary)
            }
        } header: {
            Text("In App Purchase")
        }
        .alert(isPresented: $🚨ShowError) {
            Alert(title: Text(🚨ErrorTitle),
                  message: nil,
                  dismissButton: .default(Text("OK")))
        }
        .animation(.default, value: 🏬.🚩Purchased)
    }
}
