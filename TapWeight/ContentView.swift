
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
        HKQuantity(unit: 🅄nit, doubleValue: Double(📝BodyMass10)/10)
    }
    
    var 🅀uantityBodyFat: HKQuantity {
        HKQuantity(unit: .percent(), doubleValue: Double(📝BodyFat1000)/1000)
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
    
    
    @State private var 📝BodyMass10: Int = 650
    
    @State private var 📝BodyFat1000: Int = 200
    
    var 📝BodyFatPercentage: Double {
        Double(📝BodyFat1000) / 10
    }
    
    var 📝BMI: Double {
        let 🄺iloBodyMass = 🅀uantityBodyMass.doubleValue(for: .gramUnit(with: .kilo))
        let 📝 = 🄺iloBodyMass / pow(Double(💾Height)/100, 2)
        return Double(Int(round(📝*100)))/100
    }
    
    
    @AppStorage("BodyMass") var 💾BodyMass10: Int = 600
    
    @AppStorage("BodyFat") var 💾BodyFat1000: Int = 100
    
    @AppStorage("Height") var 💾Height: Int = 165
    
    
    @AppStorage("AbleBodyFat") var 🚩BodyFat: Bool = false
    
    @AppStorage("AbleBMI") var 🚩BMI: Bool = false
    
    
    @AppStorage("history") var 🄷istory: String = ""
    
    
    @State private var 🚩InputDone: Bool = false
    
    @State private var 🚩Success: Bool = false
    
    
    @AppStorage("Unit") var 🛠Unit: 🄴numUnit = .kg
    
    
    var body: some View {
        List {
            Section {
                Stepper {
                    HStack(alignment: .firstTextBaseline) {
                        Text((Double(📝BodyMass10)/10).description)
                            .font(.system(size: 54).monospacedDigit().weight(.black))
                        
                        Text(🛠Unit.rawValue)
                            .font(.title.weight(.black))
                    }
                } onIncrement: {
                    📝BodyMass10 += 1
                } onDecrement: {
                    📝BodyMass10 -= 1
                }
                .padding()
                .onAppear {
                    📝BodyMass10 = 💾BodyMass10
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
                            Text((Double(📝BodyFat1000)/10).description)
                                .font(.system(size: 54).monospacedDigit().weight(.black))
                            
                            Text("%")
                                .font(.title.weight(.black))
                        }
                    } onIncrement: {
                        📝BodyFat1000 += 1
                    } onDecrement: {
                        📝BodyFat1000 -= 1
                    }
                    .padding()
                    .onAppear {
                        📝BodyFat1000 = 💾BodyFat1000
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
                
                🏥HealthStore.save(🄳ataBodyMass) { 🆗, 👿 in
                    if 🆗 {
                        🚩Success = true
                        print(".save/.bodyMass: Success")
                        🄷istory += Date.now.formatted(date: .numeric, time: .omitted) + ": Weight "
                        🄷istory += 🄳ataBodyMass.quantity.doubleValue(for: 🅄nit).description + " " + 🅄nit.unitString
                    } else {
                        🚩Success = false
                        print("👿:", 👿.debugDescription)
                    }
                }
                
                💾BodyMass10 = 📝BodyMass10
                
                if 🚩BodyFat {
                    🏥HealthStore.save(🄳ataBodyFat) { 🆗, 👿 in
                        if 🆗 {
                            🚩Success = true
                            print(".save/.bodyFatPercentage: Success")
                            🄷istory += " / BFP " + (🄳ataBodyFat.quantity.doubleValue(for: .percent())*100).description + " %"
                        } else {
                            🚩Success = false
                            print("👿:", 👿.debugDescription)
                        }
                    }
                    
                    💾BodyFat1000 = 📝BodyFat1000
                }
                
                if 🚩BMI {
                    🏥HealthStore.save(🄳ataBMI) { 🆗, 👿 in
                        if 🆗 {
                            🚩Success = true
                            print(".save/.bodyMassIndex: Success")
                            🄷istory += " / BMI " + 📝BMI.description
                        } else {
                            🚩Success = false
                            print("👿:", 👿.debugDescription)
                        }
                    }
                }
                
                🄷istory += "\n"
                
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
            ZStack {
                🚩Success ? Color.pink : Color.gray
                
                Button {
                    🚩InputDone = false
                } label: {
                    VStack(spacing: 16) {
                        Spacer()
                        
                        Image(systemName: 🚩Success ? "figure.wave" : "exclamationmark.triangle")
                            .font(.system(size: 128).weight(.semibold))
                        
                        Text(🚩Success ? "OK!" : "🌏Error!?")
                            .font(.system(size: 128).weight(.black))
                            .lineLimit(1)
                            .minimumScaleFactor(0.1)
                        
                        if 🚩Success == false {
                        Text("Please check permission on \"Health\" app")
                            .font(.body.weight(.semibold))
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                            .minimumScaleFactor(0.1)
                            .padding(.horizontal)
                        }
                        
                        Spacer()
                    }
                    .foregroundColor(.white)
                }
                .accessibilityLabel("🌏Dismiss")
            }
            .ignoresSafeArea()
            .preferredColorScheme(.dark)
            .overlay(alignment: .bottomTrailing) {
                💟JumpButton()
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
        .padding(24)
        .accessibilityLabel("🌏Open Apple \"Health\" app")
    }
}
