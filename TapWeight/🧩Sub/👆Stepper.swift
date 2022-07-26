
import SwiftUI

struct 👆BodyMassStepper: View {
    @EnvironmentObject var 📱: 📱AppModel
    var 🔠Font: Font { 📱.🚩AbleDatePicker ? .largeTitle : .system(size: 50) }
    
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
                    .font(🔠Font)
                    .fontWeight(.black)
                    .monospacedDigit()
                
                Text(📱.📏Unit.rawValue)
                    .font(.title2.weight(.black))
                    .frame(maxHeight: 54)
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
        .padding(8)
        .onAppear {
            📱.📝BodyMass = 📱.💾BodyMass
        }
    }
}


struct 👆BodyFatStepper: View {
    @EnvironmentObject var 📱: 📱AppModel
    var 🔠Font: Font { 📱.🚩AbleDatePicker ? .largeTitle : .system(size: 50) }
    
    var body: some View {
        Section {
            Stepper {
                HStack(alignment: .firstTextBaseline, spacing: 6) {
                    Text((round(📱.📝BodyFat*1000)/10).description)
                        .font(🔠Font)
                        .fontWeight(.black)
                        .monospacedDigit()
                    
                    Text("%")
                        .font(.title2.weight(.black))
                        .frame(maxHeight: 54)
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
            .padding(8)
            .onAppear {
                📱.📝BodyFat = 📱.💾BodyFat
            }
        } header: {
            Text("Body Fat Percentage")
        }
    }
}
