
import SwiftUI
import HealthKit


struct ContentView: View {
    @EnvironmentObject var 📱:📱Model
    
    var body: some View {
        List {
            Section {
                Stepper {
                    HStack(alignment: .firstTextBaseline) {
                        Text(📱.📝BodyMass.description)
                            .font(.system(size: 54).monospacedDigit().weight(.black))
                        
                        Text(📱.💾Unit.rawValue)
                            .font(.title.weight(.black))
                    }
                } onIncrement: {
                    📱.📝BodyMass += 0.1
                    📱.📝BodyMass = round(📱.📝BodyMass*10)/10
                } onDecrement: {
                    📱.📝BodyMass -= 0.1
                    📱.📝BodyMass = round(📱.📝BodyMass*10)/10
                }
                .padding()
                .onAppear {
                    📱.📝BodyMass = 📱.💾BodyMass
                }
                
                if 📱.🚩BMI {
                    VStack(alignment: .leading) {
                        HStack(alignment: .firstTextBaseline, spacing: 4) {
                            Text("🌏Body Mass Index")
                            
                            Text("(" + 📱.💾Height.description + "cm)")
                                .scaleEffect(0.8, anchor: .leading)
                        }
                        .font(.system(size: 14, weight: .semibold))
                        
                        Text(📱.📝BMI.description)
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
            
            
            if 📱.🚩BodyFat {
                Section {
                    Stepper {
                        HStack(alignment: .firstTextBaseline, spacing: 6) {
                            Text((round(📱.📝BodyFat*1000)/10).description)
                                .font(.system(size: 54).monospacedDigit().weight(.black))
                            
                            Text("%")
                                .font(.title.weight(.black))
                        }
                    } onIncrement: {
                        📱.📝BodyFat += 0.001
                        📱.📝BodyFat = round(📱.📝BodyFat*1000)/1000
                    } onDecrement: {
                        📱.📝BodyFat -= 0.001
                        📱.📝BodyFat = round(📱.📝BodyFat*1000)/1000
                    }
                    .padding()
                    .onAppear {
                        📱.📝BodyFat = 📱.💾BodyFat
                    }
                } header: {
                    Text("🌏Body Fat Percentage")
                }
            }
        }
        .listStyle(.plain)
        .clipped()
        .overlay(alignment: .bottom) {  // ☑️
            Button {
                📱.👆Register()
            } label: {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 120))
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(.white, .pink)
            }
            .accessibilityLabel("🌏DONE")
            .padding()
        }
        .fullScreenCover(isPresented: $📱.🚩InputDone) {
            🆗Result()
        }
        .onAppear {
            let 🅃ype: Set<HKSampleType> = [HKQuantityType(.bodyMass)]
            📱.🏥HealthStore.requestAuthorization(toShare: 🅃ype, read: nil) { 🙆, 🙅 in
                if 🙆 {
                    print("requestAuthorization/bodyMass: Success")
                } else {
                    print("🙅:", 🙅.debugDescription)
                }
            }
        }
        .onChange(of: 📱.🚩BodyFat) { _ in
            let 🅃ype: Set<HKSampleType> = [HKQuantityType(.bodyFatPercentage)]
            📱.🏥HealthStore.requestAuthorization(toShare: 🅃ype, read: nil) { 🙆, 🙅 in
                if 🙆 {
                    print("requestAuthorization/bodyFatPercentage: Success")
                } else {
                    print("🙅:", 🙅.debugDescription)
                }
            }
        }
        .onChange(of: 📱.🚩BMI) { _ in
            let 🅃ype: Set<HKSampleType> = [HKQuantityType(.bodyMassIndex)]
            📱.🏥HealthStore.requestAuthorization(toShare: 🅃ype, read: nil) { 🙆, 🙅 in
                if 🙆 {
                    print("requestAuthorization/bodyMassIndex: Success")
                } else {
                    print("🙅:", 🙅.debugDescription)
                }
            }
        }
    }
}
