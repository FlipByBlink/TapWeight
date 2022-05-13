
import SwiftUI
import HealthKit


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
    
    
    @State private var 📝BodyMass: Int = 650
    
    @State private var 📝BodyFat: Int = 200
    
    
    @AppStorage("BodyMass") var 💾BodyMass: Int = 600
    
    @AppStorage("BodyFat") var 💾BodyFat: Int = 100
    
    
    @AppStorage("AbleBodyFat") var 🚩BodyFat: Bool = false
    
    @AppStorage("LaunchHealthAppAfterLog") var 🚩LaunchHealthAppAfterLog: Bool = false
    
    
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
            } header: {
                Text("Body Mass")
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
                    Text("Body fat percentage")
                }
            }
        }
        .listStyle(.plain)
        .overlay(alignment: .bottom) {
            Button {
                🏥HealthStore.save(🄳ataBodyMass) { 🆗, 👿 in
                    if 🆗 {
                        🚩Success = true
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
                        } else {
                            🚩Success = false
                            print("👿:", 👿.debugDescription)
                        }
                    }
                    
                    💾BodyFat = 📝BodyFat
                }
                
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
            .accessibilityLabel("DONE")
        }
        .fullScreenCover(isPresented: $🚩InputDone) {
            ZStack {
                🚩Success ? Color.pink : Color.gray
                
                VStack(spacing: 16) {
                    Image(systemName: 🚩Success ? "heart" : "heart.slash")
                    
                    Text(🚩Success ? "OK!" : "Error!?")
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
    }
}
