
import SwiftUI

struct 💸AdSection: View {
    var body: some View {
        Section {
            💸AdView(.FlipByBlink)
                .padding(.leading, 4)
            💸AdView(.FadeInAlarm)
                .padding(.leading, 4)
            💸AdView(.Plain将棋盤)
                .padding(.leading, 4)
            💸AdView(.TapTemperature)
                .padding(.leading, 4)
        } header: {
            Text("🌏self-AD")
        }
    }
}
