
import SwiftUI
import HealthKit


enum 🄴numUnit: String, CaseIterable {
    case kg
    case lbs
    case st
}


struct ContentView: View {
    
    let 🏥HealthStore = HKHealthStore()
    
    var 🅄nit: HKUnit {
        switch 🛠Unit {
        case .kg: return .gramUnit(with: .kilo)
        case .lbs: return .pound()
        case .st: return .stone()
        }
    }
    
    var 🅀uantityBodyMass: HKQuantity {
        HKQuantity(unit: 🅄nit, doubleValue: Double(📝BodyMass)/10)
    }
    
    var 🅀uantityBodyFat: HKQuantity {
        HKQuantity(unit: .percent(), doubleValue: Double(📝BodyFat)/1000)
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
    
    
    @State private var 📝BodyMass: Int = 650
    
    @State private var 📝BodyFat: Int = 200
    
    var 📝BMI: Double {
        let 📝 = Double(📝BodyMass)/10 / pow(Double(💾Height)/100, 2)
        return round(📝*100) / 100
    }
    
    
    @AppStorage("BodyMass") var 💾BodyMass: Int = 600
    
    @AppStorage("BodyFat") var 💾BodyFat: Int = 100
    
    @AppStorage("BMI") var 💾BMI: Double = 100
    
    @AppStorage("Height") var 💾Height: Int = 165
    
    
    @AppStorage("AbleBodyFat") var 🚩BodyFat: Bool = false
    
    @AppStorage("AbleBMI") var 🚩BMI: Bool = false
    
    @AppStorage("LaunchHealthAppAfterLog") var 🚩LaunchHealthAppAfterLog: Bool = false
    
    
    @AppStorage("history") var 🄷istory: String = ""
    
    
    @State private var 🚩InputDone: Bool = false
    
    @State private var 🚩Success: Bool = false
    
    
    @AppStorage("Unit") var 🛠Unit: 🄴numUnit = .kg
    
    
    var body: some View {
        List {
            Section {
                Stepper {
                    HStack(alignment: .firstTextBaseline) {
                        Text((Double(📝BodyMass)/10).description)
                            .font(.system(size: 54).monospacedDigit().weight(.black))
                        
                        Text(🛠Unit.rawValue)
                            .font(.title.weight(.black))
                    }
                } onIncrement: {
                    📝BodyMass += 1
                } onDecrement: {
                    📝BodyMass -= 1
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
                            Text((Double(📝BodyFat)/10).description)
                                .font(.system(size: 54).monospacedDigit().weight(.black))
                            
                            Text("%")
                                .font(.title.weight(.black))
                        }
                    } onIncrement: {
                        📝BodyFat += 1
                    } onDecrement: {
                        📝BodyFat -= 1
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
        .overlay(alignment: .bottom) {
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
                
                🏥HealthStore.save(🄳ataBodyMass) { 🆗, 👿 in
                    if 🆗 {
                        🚩Success = true
                        print(".save/.bodyMass: Success")
                        🄷istory += Date.now.formatted(date: .numeric, time: .omitted) + " : "
                        🄷istory += 🄳ataBodyMass.quantity.doubleValue(for: 🅄nit).description + " " + 🅄nit.unitString
                    } else {
                        🚩Success = false
                        print("👿:", 👿.debugDescription)
                    }
                }
                
                💾BodyMass = 📝BodyMass
                
                if 🚩BodyFat {
                    🏥HealthStore.save(🄳ataBodyFat) { 🆗, 👿 in
                        if 🆗 {
                            🚩Success = true
                            print(".save/.bodyFatPercentage: Success")
                            🄷istory += " / " + (🄳ataBodyFat.quantity.doubleValue(for: .percent())*100).description + " %"
                        } else {
                            🚩Success = false
                            print("👿:", 👿.debugDescription)
                        }
                    }
                    
                    💾BodyFat = 📝BodyFat
                }
                
                if 🚩BMI {
                    🏥HealthStore.save(🄳ataBMI) { 🆗, 👿 in
                        if 🆗 {
                            🚩Success = true
                            print(".save/.bodyMassIndex: Success")
                            🄷istory += " / " + 🄳ataBMI.quantity.doubleValue(for: .count()).description
                        } else {
                            🚩Success = false
                            print("👿:", 👿.debugDescription)
                        }
                    }
                    
                    💾BMI = 📝BMI
                }
                
                🄷istory += "\n"
                
                if 🚩LaunchHealthAppAfterLog {
                    let 📍 = URL(string: "x-apple-health://")!
                    UIApplication.shared.open(📍)
                } else {
                    🚩InputDone = true
                }
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
            ZStack {
                🚩Success ? Color.pink : Color.gray
                
                VStack(spacing: 16) {
                    Image(systemName: 🚩Success ? "heart" : "heart.slash")
                    
                    Text(🚩Success ? "OK!" : "🌏Error!?")
                        .lineLimit(1)
                        .minimumScaleFactor(0.1)
                }
                .font(.system(size: 128).weight(.black))
                .foregroundColor(.white)
            }
            .ignoresSafeArea()
            .statusBar(hidden: true)
            .onTapGesture {
                🚩InputDone = false
            }
            .overlay {
                🗯AdView()
            }
        }
        .onAppear {
            let 🅃ype: Set<HKSampleType> = [HKQuantityType(.bodyMass)]
            🏥HealthStore.requestAuthorization(toShare: 🅃ype, read: nil) { 🆗, 👿 in
                if 🆗 {
                    print("requestAuthorization/bodyMass: Success")
                } else {
                    print("👿:", 👿.debugDescription)
                }
            }
        }
        .onChange(of: 🚩BodyFat) { _ in
            let 🅃ype: Set<HKSampleType> = [HKQuantityType(.bodyFatPercentage)]
            🏥HealthStore.requestAuthorization(toShare: 🅃ype, read: nil) { 🆗, 👿 in
                if 🆗 {
                    print("requestAuthorization/bodyFatPercentage: Success")
                } else {
                    print("👿:", 👿.debugDescription)
                }
            }
        }
        .onChange(of: 🚩BMI) { _ in
            let 🅃ype: Set<HKSampleType> = [HKQuantityType(.bodyMassIndex)]
            🏥HealthStore.requestAuthorization(toShare: 🅃ype, read: nil) { 🆗, 👿 in
                if 🆗 {
                    print("requestAuthorization/bodyMassIndex: Success")
                } else {
                    print("👿:", 👿.debugDescription)
                }
            }
        }
    }
}
