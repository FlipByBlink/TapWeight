
import SwiftUI

struct 👆BodyMassStepper: View {
    @EnvironmentObject var 📱: 📱AppModel
    var 🔠Font: Font { 📱.🚩AbleDatePicker ? .largeTitle : .system(size: 50) }
    var 🪧Description: String {
        if 📱.🚩Amount50g && 📱.📝MassValue.description.count == 4 {
            return 📱.📝MassValue.description + "0"
        } else {
            return 📱.📝MassValue.description
        }
    }
    
    var body: some View {
        Stepper {
            HStack(alignment: .firstTextBaseline) {
                Text(🪧Description)
                    .font(🔠Font)
                    .fontWeight(.black)
                    .monospacedDigit()
                
                Text(📱.📏MassUnit.rawValue)
                    .font(.title2.weight(.black))
                    .frame(maxHeight: 36)
                Spacer(minLength: 0)
                📉DifferenceView()
            }
        } onIncrement: {
            UISelectionFeedbackGenerator().selectionChanged()
            if 📱.🚩Amount50g {
                📱.📝MassValue += 0.05
                📱.📝MassValue = round(📱.📝MassValue*100)/100
            } else {
                📱.📝MassValue += 0.1
                📱.📝MassValue = round(📱.📝MassValue*10)/10
            }
        } onDecrement: {
            UISelectionFeedbackGenerator().selectionChanged()
            if 📱.🚩Amount50g {
                📱.📝MassValue -= 0.05
                📱.📝MassValue = round(📱.📝MassValue*100)/100
            } else {
                📱.📝MassValue -= 0.1
                📱.📝MassValue = round(📱.📝MassValue*10)/10
            }
        }
        .padding(8)
        .padding(.vertical, 4)
        .onAppear {
            guard let 📝 = 📱.🕘LocalHistory.ⓛogs.last?.entry?.massSample.value else { return }
            📱.📝MassValue = 📝
        }
    }
    
    struct 📉DifferenceView: View {
        @EnvironmentObject var 📱: 📱AppModel
        var 📉DifferenceAmount: Double? {
            guard let 📝LastValue = 📱.🕘LocalHistory.ⓛogs.last?.entry?.massSample.value else { return nil }
            return (round((📱.📝MassValue - 📝LastValue)*100)/100)
        }
        
        var body: some View {
            Group {
                if let 📉 = 📉DifferenceAmount {
                    switch 📉 {
                        case ..<0:
                            Text(📉.description)
                        case 0...:
                            Text("+" + 📉.description)
                                .opacity(📉.isZero ? 0 : 1 )
                        default: Text("🐛")
                    }
                }
            }
            .font(.body.weight(.heavy))
            .monospacedDigit()
            .foregroundStyle(.quaternary)
            .minimumScaleFactor(0.1)
            .frame(maxWidth: 48 ,maxHeight: 32)
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
                    Text((round(📱.📝BodyFatValue*1000)/10).description)
                        .font(🔠Font)
                        .fontWeight(.black)
                        .monospacedDigit()
                    
                    Text("%")
                        .font(.title2.weight(.black))
                        .frame(maxHeight: 54)
                    Spacer(minLength: 0)
                    📉DifferenceView()
                }
            } onIncrement: {
                UISelectionFeedbackGenerator().selectionChanged()
                📱.📝BodyFatValue += 0.001
                📱.📝BodyFatValue = round(📱.📝BodyFatValue*1000)/1000
            } onDecrement: {
                UISelectionFeedbackGenerator().selectionChanged()
                📱.📝BodyFatValue -= 0.001
                📱.📝BodyFatValue = round(📱.📝BodyFatValue*1000)/1000
            }
            .padding(8)
            .padding(.vertical, 4)
            .onAppear {
                guard let 📝 = 📱.🕘LocalHistory.ⓛogs.last?.entry?.bodyFatValue else { return }
                📱.📝BodyFatValue = 📝
            }
        } header: {
            Text("Body Fat Percentage")
        }
    }
    
    struct 📉DifferenceView: View {
        @EnvironmentObject var 📱: 📱AppModel
        var 📉DifferenceAmount: Double? {
            guard let 📝LastValue = 📱.🕘LocalHistory.ⓛogs.last?.entry?.bodyFatValue else { return nil }
            return (round((📱.📝BodyFatValue - 📝LastValue)*1000)/10)
        }
        
        var body: some View {
            Group {
                if let 📉 = 📉DifferenceAmount {
                    switch 📉 {
                        case ..<0:
                            Text(📉.description)
                        case 0...:
                            Text("+" + 📉.description)
                                .opacity(📉.isZero ? 0 : 1 )
                        default: Text("🐛")
                    }
                }
            }
            .font(.body.weight(.heavy))
            .monospacedDigit()
            .foregroundStyle(.quaternary)
            .minimumScaleFactor(0.1)
            .frame(maxWidth: 48 ,maxHeight: 32)
        }
    }
}
