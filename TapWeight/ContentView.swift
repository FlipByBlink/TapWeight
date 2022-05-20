
import SwiftUI
import HealthKit


enum 📏Enum: String, CaseIterable {
    case kg
    case lbs
    case st
    
    var 🅄nit: HKUnit {
        switch self {
            case .kg: return .gramUnit(with: .kilo)
            case .lbs: return .pound()
            case .st: return .stone()
        }
    }
}


struct ContentView: View {
    
    let 🏥HealthStore = HKHealthStore()
    
    @AppStorage("Unit") var 📏: 📏Enum = .kg
    
    var 🅀uantityBodyMass: HKQuantity {
        HKQuantity(unit: 📏.🅄nit, doubleValue: 📝BodyMass)
    }
    
    var 🅀uantityBodyFat: HKQuantity {
        HKQuantity(unit: .percent(), doubleValue: 📝BodyFat)
    }
    
    var 🅀uantityBMI: HKQuantity {
        HKQuantity(unit: .count(), doubleValue: 📝BMI)
    }
    
    var 🄳ataBodyMass: HKQuantitySample {
        HKQuantitySample(type: HKQuantityType(.bodyMass),
                         quantity: 🅀uantityBodyMass,
                         start: .now,
                         end: .now)
    }
    
    var 🄳ataBodyFat: HKQuantitySample {
        HKQuantitySample(type: HKQuantityType(.bodyFatPercentage),
                         quantity: 🅀uantityBodyFat,
                         start: .now,
                         end: .now)
    }
    
    var 🄳ataBMI: HKQuantitySample {
        HKQuantitySample(type: HKQuantityType(.bodyMassIndex),
                         quantity: 🅀uantityBMI,
                         start: .now,
                         end: .now)
    }
    
    
    @State private var 📝BodyMass: Double = 65.0
    
    @State private var 📝BodyFat: Double = 0.2
    
    
    var 📝BMI: Double {
        let 🄺iloBodyMass = 🅀uantityBodyMass.doubleValue(for: .gramUnit(with: .kilo))
        let 📝 = 🄺iloBodyMass / pow(Double(💾Height)/100, 2)
        return Double(Int(round(📝*100)))/100
    }
    
    
    @AppStorage("BodyMass") var 💾BodyMass: Double = 60.0
    
    @AppStorage("BodyFat") var 💾BodyFat: Double = 0.1
    
    @AppStorage("Height") var 💾Height: Int = 165
    
    
    @AppStorage("AbleBodyFat") var 🚩BodyFat: Bool = false
    
    @AppStorage("AbleBMI") var 🚩BMI: Bool = false
    
    
    @AppStorage("historyBodyMass") var 🄷istoryBodyMass: String = ""
    
    @AppStorage("historyBodyFat") var 🄷istoryBodyFat: String = ""
    
    @AppStorage("historyBMI") var 🄷istoryBMI: String = ""
    
    
    @State private var 🚩InputDone: Bool = false
    
    @State private var 🚩Success: Bool = false
    
    
    var body: some View {
        List {
            Section {
                Stepper {
                    HStack(alignment: .firstTextBaseline) {
                        Text(📝BodyMass.description)
                            .font(.system(size: 54).monospacedDigit().weight(.black))
                        
                        Text(📏.rawValue)
                            .font(.title.weight(.black))
                    }
                } onIncrement: {
                    📝BodyMass += 0.1
                    📝BodyMass = round(📝BodyMass*10)/10
                } onDecrement: {
                    📝BodyMass -= 0.1
                    📝BodyMass = round(📝BodyMass*10)/10
                }
                .padding()
                .onAppear {
                    📝BodyMass = 💾BodyMass
                }
                
                if 🚩BMI {
                    VStack(alignment: .leading) {
                        HStack(alignment: .firstTextBaseline, spacing: 4) {
                            Text("🌏Body Mass Index")
                            
                            Text("(" + 💾Height.description + "cm)")
                                .scaleEffect(0.8, anchor: .leading)
                        }
                        .font(.system(size: 14, weight: .semibold))
                        
                        Text(📝BMI.description)
                            .font(.title)
                            .fontWeight(.bold)
                    }
                    .padding(12)
                    .padding(.leading, 32)
                    .monospacedDigit()
                    .foregroundStyle(.secondary)
                }
            } header: {
                Text("🌏Body Mass")
            }
            
            
            if 🚩BodyFat {
                Section {
                    Stepper {
                        HStack(alignment: .firstTextBaseline, spacing: 6) {
                            Text((round(📝BodyFat*1000)/10).description)
                                .font(.system(size: 54).monospacedDigit().weight(.black))
                            
                            Text("%")
                                .font(.title.weight(.black))
                        }
                    } onIncrement: {
                        📝BodyFat += 0.001
                        📝BodyFat = round(📝BodyFat*1000)/1000
                    } onDecrement: {
                        📝BodyFat -= 0.001
                        📝BodyFat = round(📝BodyFat*1000)/1000
                    }
                    .padding()
                    .onAppear {
                        📝BodyFat = 💾BodyFat
                    }
                } header: {
                    Text("🌏Body Fat Percentage")
                }
            }
        }
        .listStyle(.plain)
        .overlay(alignment: .bottom) {  // ☑️
            Button {
                UISelectionFeedbackGenerator().selectionChanged()
                
                if 🏥HealthStore.authorizationStatus(for: HKQuantityType(.bodyMass)) == .sharingDenied {
                    🚩Success = false
                    🚩InputDone = true
                    return
                }
                
                if 🚩BodyFat {
                    if 🏥HealthStore.authorizationStatus(for: HKQuantityType(.bodyFatPercentage)) == .sharingDenied {
                        🚩Success = false
                        🚩InputDone = true
                        return
                    }
                }
                
                if 🚩BMI {
                    if 🏥HealthStore.authorizationStatus(for: HKQuantityType(.bodyMassIndex)) == .sharingDenied {
                        🚩Success = false
                        🚩InputDone = true
                        return
                    }
                }
                
                🏥HealthStore.save(🄳ataBodyMass) { 🙆, 🙅 in
                    🄷istoryBodyMass += Date.now.formatted(date: .numeric, time: .shortened) + ": BodyMass "
                    
                    if 🙆 {
                        🚩Success = true
                        🄷istoryBodyMass += 📝BodyMass.description + " " + 📏.🅄nit.unitString + "\n"
                        💾BodyMass = 📝BodyMass
                    } else {
                        🚩Success = false
                        print("🙅:", 🙅.debugDescription)
                        🄷istoryBodyMass += "HealthStore.save error?!\n"
                        return
                    }
                }
                
                if 🚩BodyFat {
                    🄷istoryBodyFat += Date.now.formatted(date: .numeric, time: .shortened) + ": BodyFat "
                    
                    🏥HealthStore.save(🄳ataBodyFat) { 🙆, 🙅 in
                        if 🙆 {
                            🚩Success = true
                            🄷istoryBodyFat += (round(📝BodyFat*1000)/10).description + " %\n"
                            💾BodyFat = 📝BodyFat
                        } else {
                            🚩Success = false
                            print("🙅:", 🙅.debugDescription)
                            🄷istoryBodyFat += "HealthStore.save error?!\n"
                            return
                        }
                    }
                }
                
                if 🚩BMI {
                    🄷istoryBMI += Date.now.formatted(date: .numeric, time: .shortened) + ": BMI "
                    
                    🏥HealthStore.save(🄳ataBMI) { 🙆, 🙅 in
                        if 🙆 {
                            🚩Success = true
                            🄷istoryBMI += 📝BMI.description + "\n"
                        } else {
                            🚩Success = false
                            print("🙅:", 🙅.debugDescription)
                            🄷istoryBMI += "HealthStore.save error?!\n"
                            return
                        }
                    }
                }
                
                🚩InputDone = true
            } label: {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 120))
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(.white, .pink)
                    .padding()
            }
            .accessibilityLabel("🌏DONE")
        }
        .fullScreenCover(isPresented: $🚩InputDone) {
            🆗Result($🚩Success)
        }
        .onAppear {
            let 🅃ype: Set<HKSampleType> = [HKQuantityType(.bodyMass)]
            🏥HealthStore.requestAuthorization(toShare: 🅃ype, read: nil) { 🙆, 🙅 in
                if 🙆 {
                    print("requestAuthorization/bodyMass: Success")
                } else {
                    print("🙅:", 🙅.debugDescription)
                }
            }
        }
        .onChange(of: 🚩BodyFat) { _ in
            let 🅃ype: Set<HKSampleType> = [HKQuantityType(.bodyFatPercentage)]
            🏥HealthStore.requestAuthorization(toShare: 🅃ype, read: nil) { 🙆, 🙅 in
                if 🙆 {
                    print("requestAuthorization/bodyFatPercentage: Success")
                } else {
                    print("🙅:", 🙅.debugDescription)
                }
            }
        }
        .onChange(of: 🚩BMI) { _ in
            let 🅃ype: Set<HKSampleType> = [HKQuantityType(.bodyMassIndex)]
            🏥HealthStore.requestAuthorization(toShare: 🅃ype, read: nil) { 🙆, 🙅 in
                if 🙆 {
                    print("requestAuthorization/bodyMassIndex: Success")
                } else {
                    print("🙅:", 🙅.debugDescription)
                }
            }
        }
    }
}


struct 💟JumpButton: View {
    var body: some View {
        Link(destination: URL(string: "x-apple-health://")!) {
            Image(systemName: "app")
                .imageScale(.large)
                .overlay {
                    Image(systemName: "heart")
                        .imageScale(.small)
                }
        }
        .font(.largeTitle)
        .foregroundStyle(.secondary)
        .padding(.bottom, 24)
        .padding(.trailing, 24)
        .accessibilityLabel("🌏Open \"Health\" app")
    }
}
