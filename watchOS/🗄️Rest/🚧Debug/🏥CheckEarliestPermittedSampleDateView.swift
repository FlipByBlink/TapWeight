import SwiftUI

#if DEBUG
struct 🏥CheckEarliestPermittedSampleDateView: View {
    @EnvironmentObject var 📱: 📱AppModel
    var body: some View {
        Text(📱.🏥healthStore.api.earliestPermittedSampleDate(), style: .offset)
        //Almost 1 week ago on Apple Watch
    }
}
#endif
