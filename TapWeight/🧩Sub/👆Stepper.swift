
import SwiftUI

struct 👆BodyMassStepper: View {
    @EnvironmentObject var 📱: 📱AppModel
    
    var body: some View {
        Stepper {
            HStack(alignment: .firstTextBaseline) {
                let 🪧BodyMass: String = {
                    if 📱.🚩Amount50g && 📱.📝BodyMass.description.count == 4 {
                        return 📱.📝BodyMass.description + "0"
                    } else {
                        return 📱.📝BodyMass.description
                    }
                }()
                
                Text(🪧BodyMass)
                    .font(.system(size: 54).monospacedDigit().weight(.black))
                    .lineLimit(1)
                    .minimumScaleFactor(0.1)
                
                Text(📱.📏Unit.rawValue)
                    .font(.title.weight(.black))
                    .padding(.trailing, 8)
            }
        } onIncrement: {
            UISelectionFeedbackGenerator().selectionChanged()
            if 📱.🚩Amount50g {
                📱.📝BodyMass += 0.05
                📱.📝BodyMass = round(📱.📝BodyMass*100)/100
            } else {
                📱.📝BodyMass += 0.1
                📱.📝BodyMass = round(📱.📝BodyMass*10)/10
            }
        } onDecrement: {
            UISelectionFeedbackGenerator().selectionChanged()
            if 📱.🚩Amount50g {
                📱.📝BodyMass -= 0.05
                📱.📝BodyMass = round(📱.📝BodyMass*100)/100
            } else {
                📱.📝BodyMass -= 0.1
                📱.📝BodyMass = round(📱.📝BodyMass*10)/10
            }
        }
        .padding()
        .onAppear {
            📱.📝BodyMass = 📱.💾BodyMass
        }
    }
}


struct 👆BodyFatStepper: View {
    @EnvironmentObject var 📱: 📱AppModel
    
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
