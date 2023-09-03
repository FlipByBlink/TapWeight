import SwiftUI

struct 🗯ResultView: View {
    @EnvironmentObject var 📱: 📱AppModel
    @State private var ⓢhowUndoAlert: Bool = false
    private var ⓒanceled: Bool { 📱.🚩completedCancellation }
    var body: some View {
        VStack {
            Spacer()
            Image(systemName: "checkmark")
                .font(.largeTitle.bold())
            Text("DONE!")
                .font(.title.bold())
            Spacer()
            Text(📱.ⓡesultSummaryDescription)
                .font(.body.bold())
                .lineLimit(2)
                .multilineTextAlignment(.center)
            Spacer()
        }
        .minimumScaleFactor(0.1)
        .padding(.horizontal)
        .strikethrough(self.ⓒanceled)
        .opacity(self.ⓒanceled ? 0.25 : 1)
        .overlay(alignment: .bottom) {
            if self.ⓒanceled {
                Text("Canceled")
                    .fontWeight(.semibold)
            }
        }
        .onTapGesture {
            if !self.ⓒanceled { self.ⓢhowUndoAlert = true }
        }
        .confirmationDialog("Undo?", isPresented: self.$ⓢhowUndoAlert) {
            Button("Yes, undo") { 📱.🗑cancel() }
        }
        .modifier(🚨CancellationErrorAlert())
        .toolbar(.hidden, for: .automatic)
    }
    //Dismiss by pushing DigitalCrown
}
