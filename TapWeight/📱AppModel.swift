
import SwiftUI
import HealthKit

class 📱AppModel: ObservableObject {
    @AppStorage("Unit") var 📏MassUnit: 📏BodyMassUnit = .kg
    @AppStorage("Amount50g") var 🚩Amount50g: Bool = false
    @AppStorage("AbleBMI") var 🚩AbleBMI: Bool = false
    @AppStorage("Height") var 🧍HeightValue: Int = 165
    @AppStorage("AbleBodyFat") var 🚩AbleBodyFat: Bool = false
    @AppStorage("AbleDatePicker") var 🚩AbleDatePicker: Bool = false
    
    @Published var 📝MassValue: Double = 65.0
    var 📝BMIValue: Double {
        let ⓠuantity = HKQuantity(unit: 📏MassUnit.hkunit, doubleValue: 📝MassValue)
        let ⓚiloMassValue = ⓠuantity.doubleValue(for: .gramUnit(with: .kilo))
        let ⓥalue = ⓚiloMassValue / pow(Double(🧍HeightValue)/100, 2)
        return Double(Int(round(ⓥalue*10)))/10
    }
    @Published var 📝BodyFatValue: Double = 0.2
    
    @Published var 💾LastSamples: [HKQuantityTypeIdentifier: HKQuantitySample] = [:]
    
    @Published var 📅PickerValue = Date.now
    var 🚩DatePickerIsAlmostNow: Bool { 📅PickerValue.timeIntervalSinceNow > -300 }
    
    @Published var 🚨RegisterError: Bool = false
    @Published var 🚩Canceled: Bool = false
    @Published var 🚨CancelError: Bool = false
    
    @Published var 🕘LocalHistory = 🕘LocalHistoryModel()
    
    let 🏥HealthStore = HKHealthStore()
    var 📦Samples: [HKQuantitySample] = []
    
    @MainActor
    func 👆Register() async {
        UINotificationFeedbackGenerator().notificationOccurred(.success)
        
        if 🏥CheckAuthDenied(.bodyMass) { return }
        
        if 🚩AbleBMI {
            if 🏥CheckAuthDenied(.bodyMassIndex) { return }
        }
        
        if 🚩AbleBodyFat {
            if 🏥CheckAuthDenied(.bodyFatPercentage) { return }
        }
        
        let 📅Date: Date = 🚩AbleDatePicker ? 📅PickerValue : .now
        
        📦Samples.append(HKQuantitySample(type: HKQuantityType(.bodyMass),
                                          quantity: HKQuantity(unit: 📏MassUnit.hkunit, doubleValue: 📝MassValue),
                                          start: 📅Date, end: 📅Date))
        
        if 🚩AbleBMI {
            📦Samples.append(HKQuantitySample(type: HKQuantityType(.bodyMassIndex),
                                              quantity: HKQuantity(unit: .count(), doubleValue: 📝BMIValue),
                                              start: 📅Date, end: 📅Date))
        }
        
        if 🚩AbleBodyFat {
            📦Samples.append(HKQuantitySample(type: HKQuantityType(.bodyFatPercentage),
                                              quantity: HKQuantity(unit: .percent(), doubleValue: 📝BodyFatValue),
                                              start: 📅Date, end: 📅Date))
        }
        
        do {
            try await 🏥HealthStore.save(📦Samples)
            🕘SaveLogForLocalHistory(📅Date)
        } catch {
            🕘LocalHistory.addLog("Error: " + #function + error.localizedDescription)
            🚨RegisterError = true
        }
    }
    
    func 🏥CheckAuthDenied(_ ⓣype: HKQuantityTypeIdentifier) -> Bool {
        if 🏥HealthStore.authorizationStatus(for: HKQuantityType(ⓣype)) == .sharingDenied {
            🚨RegisterError = true
            self.🕘LocalHistory.addLog("Error: " + #function + ⓣype.rawValue)
            return true
        } else {
            return false
        }
    }
    
    func 🏥CheckShouldRequestAuth(_ identifier: HKQuantityTypeIdentifier) async throws -> Bool {
        let ⓣype = HKQuantityType(identifier)
        return try await 🏥HealthStore.statusForAuthorizationRequest(toShare: [ⓣype], read: [ⓣype]) == .shouldRequest
    }
    
    func 🏥RequestAuth(_ ⓘdentifier: HKQuantityTypeIdentifier) {
        Task {
            do {
                if try await 🏥CheckShouldRequestAuth(ⓘdentifier) {
                    let ⓣype = HKQuantityType(ⓘdentifier)
                    try await 🏥HealthStore.requestAuthorization(toShare: [ⓣype], read: [ⓣype])
                    🏥GetLatestValue()
                }
            } catch {
                self.🕘LocalHistory.addLog("Error: " + #function + error.localizedDescription)
            }
        }
    }
    
    func 🏥CheckAuthOnLaunch() {
        Task {
            do {
                var ⓣypes: Set<HKSampleType> = []
                
                if try await 🏥CheckShouldRequestAuth(.bodyMass) {
                    ⓣypes.insert(HKQuantityType(.bodyMass))
                }
                
                if 🚩AbleBMI {
                    if try await 🏥CheckShouldRequestAuth(.bodyMassIndex) {
                        ⓣypes.insert(HKQuantityType(.bodyMassIndex))
                    }
                }
                
                if 🚩AbleBodyFat {
                    if try await 🏥CheckShouldRequestAuth(.bodyFatPercentage) {
                        ⓣypes.insert(HKQuantityType(.bodyFatPercentage))
                    }
                }
                
                if !ⓣypes.isEmpty {
                    if try await 🏥HealthStore.statusForAuthorizationRequest(toShare: ⓣypes, read: ⓣypes) == .shouldRequest {
                        try await 🏥HealthStore.requestAuthorization(toShare: ⓣypes, read: ⓣypes)
                        if ⓣypes.contains(HKQuantityType(.bodyMass)) { try await 🏥GetPreferredMassUnit() }
                        🏥GetLatestValue()
                    }
                }
            } catch {
                🕘LocalHistory.addLog("Error: " + #function + error.localizedDescription)
            }
        }
    }
    
    func 🏥GetLatestValue() {
        let ⓘdentifiers: [HKQuantityTypeIdentifier] = [.bodyMass, .bodyMassIndex, .bodyFatPercentage]
        
        for ⓘdentifier in ⓘdentifiers {
            let ⓠuery = HKSampleQuery(sampleType: HKQuantityType(ⓘdentifier),
                                      predicate: nil,
                                      limit: 1,
                                      sortDescriptors: [NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)]) { _, ⓢamples, _ in
                DispatchQueue.main.async {
                    if let ⓢample = ⓢamples?.first as? HKQuantitySample {
                        switch ⓘdentifier {
                            case .bodyMass:
                                let ⓥalue = ⓢample.quantity.doubleValue(for: self.📏MassUnit.hkunit)
                                if self.🚩Amount50g {
                                    self.📝MassValue = round(ⓥalue*20)/20
                                } else {
                                    self.📝MassValue = round(ⓥalue*10)/10
                                }
                                
                                self.💾LastSamples[.bodyMass] = ⓢample
                            case .bodyMassIndex:
                                self.💾LastSamples[.bodyMassIndex] = ⓢample
                            case .bodyFatPercentage:
                                self.📝BodyFatValue = ⓢample.quantity.doubleValue(for: .percent())
                                self.💾LastSamples[.bodyFatPercentage] = ⓢample
                            default: print("🐛")
                        }
                    }
                }
            }
            
            🏥HealthStore.execute(ⓠuery)
        }
    }
    
    @MainActor
    func 🗑Cancel() {
        Task {
            do {
                🚩Canceled = true
                try await 🏥HealthStore.delete(📦Samples)
                🏥GetLatestValue()
                🕘LocalHistory.modifyCancellation()
                UINotificationFeedbackGenerator().notificationOccurred(.error)
            } catch {
                🕘LocalHistory.addLog("Error: " + error.localizedDescription)
                🚨CancelError = true
            }
        }
    }
    
    @MainActor
    func 🏥GetPreferredMassUnit() async throws {
        if let 📏 = try await 🏥HealthStore.preferredUnits(for: [HKQuantityType(.bodyMass)]).first {
            switch 📏.value {
                case .gramUnit(with: .kilo):
                    📏MassUnit = .kg
                    📝MassValue = 60
                case .pound():
                    📏MassUnit = .lbs
                    📝MassValue = 130
                case .stone():
                    📏MassUnit = .st
                    📝MassValue = 10
                default: print("🐛")
            }
        }
    }
    
    func 🅁eset() {
        🚨RegisterError = false
        🚩Canceled = false
        🚨CancelError = false
        📦Samples = []
        🏥GetLatestValue()
    }
    
    func 🕘SaveLogForLocalHistory(_ ⓓate: Date) {
        var ⓔntry = 🕘Entry(date: ⓓate, massSample: .init(unit: 📏MassUnit, value: 📝MassValue))
        if 🚩AbleBMI { ⓔntry.bmiValue = 📝BMIValue }
        if 🚩AbleBodyFat { ⓔntry.bodyFatValue = 📝BodyFatValue }
        🕘LocalHistory.addLog(ⓔntry)
    }
    
    func 🕘LoadLastValueFromLocalHistoryOnLaunch() {
        let ⓔntrys = 🕘LocalHistory.ⓛogs.compactMap { $0.entry }
        let ⓔntry = ⓔntrys.max { $0.date < $1.date }
        guard let ⓛastEntry = ⓔntry else { return }
        if ⓛastEntry.cancellation { return }
        📝MassValue = ⓛastEntry.massSample.value
        if let ⓥalue = ⓛastEntry.bodyFatValue {
            📝BodyFatValue = ⓥalue
        }
    }
    
    init() {
        🕘LoadLastValueFromLocalHistoryOnLaunch()
    }
}
