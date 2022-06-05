
import SwiftUI

struct 👆BodyFatStepper: View {
    @EnvironmentObject var 📱:📱Model
    
    var body: some View {
        Section {
            Stepper {
                HStack(alignment: .firstTextBaseline, spacing: 6) {
                    Text((round(📱.📝BodyFat*1000)/10).description)
                        .font(.system(size: 54).monospacedDigit().weight(.black))
                        .lineLimit(1)
                        .minimumScaleFactor(0.1)
                    
                    Text("%")
                        .font(.title.weight(.black))
                }
            } onIncrement: {
                UISelectionFeedbackGenerator().selectionChanged()
                📱.📝BodyFat += 0.001
                📱.📝BodyFat = round(📱.📝BodyFat*1000)/1000
            } onDecrement: {
                UISelectionFeedbackGenerator().selectionChanged()
                📱.📝BodyFat -= 0.001
                📱.📝BodyFat = round(📱.📝BodyFat*1000)/1000
            }
            .padding()
            .onAppear {
                📱.📝BodyFat = 📱.💾BodyFat
            }
        } header: {
            Text("Body Fat Percentage")
        }
    }
}
