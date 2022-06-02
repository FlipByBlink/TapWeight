
import SwiftUI

struct 💟JumpButton: View {
    var body: some View {
        Link(destination: URL(string: "x-apple-health://")!) {
            Image(systemName: "app")
                .imageScale(.large)
                .overlay {
                    Image(systemName: "heart")
                        .imageScale(.small)
                }
                .font(.largeTitle)
                .padding(.bottom, 24)
                .padding(.trailing, 24)
        }
        .foregroundStyle(.secondary)
        .accessibilityLabel("🌏Open \"Health\" app")
    }
}
