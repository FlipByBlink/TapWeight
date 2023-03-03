import SwiftUI

struct 💟OpenHealthAppButton: View {
    var body: some View {
        Link(destination: URL(string: "x-apple-health://")!) {
            Label {
                Text("Open \"Health\" app")
            } icon: {
                Image(systemName: "app")
                    .imageScale(.large)
                    .overlay {
                        Image(systemName: "heart")
                            .resizable()
                            .font(.body.weight(.semibold))
                            .scaleEffect(0.5)
                    }
            }
        }
    }
}
