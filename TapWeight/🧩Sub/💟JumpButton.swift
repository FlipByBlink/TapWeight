import SwiftUI

struct 💟JumpButton: View {
    var body: some View {
        Link(destination: URL(string: "x-apple-health://")!) {
            Label {
                Text("Open \"Health\" app")
            } icon: {
                Image(systemName: "app")
                    .imageScale(.large)
                    .overlay {
                        Image(systemName: "heart")
                            .imageScale(.small)
                    }
            }
        }
    }
}
