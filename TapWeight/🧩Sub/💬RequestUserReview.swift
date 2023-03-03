import SwiftUI

struct 💬RequestUserReview: ViewModifier {
    @State private var ⓒheckToRequest: Bool = false
    func body(content: Content) -> some View {
        content
            .modifier(💬PrepareToRequestUserReview(self.$ⓒheckToRequest))
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.ⓒheckToRequest = true
                }
            }
    }
}
