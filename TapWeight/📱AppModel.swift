
import SwiftUI
import HealthKit

class 📱AppModel: ObservableObject {
    
    @Published var 🚩ShowMenu: Bool = false
    
    @AppStorage("Unit") var 📏MassUnit: 📏BodyMassUnit = .kg
    @AppStorage("Amount50g") var 🚩Amount50g: Bool = false
    @AppStorage("AbleBMI") var 🚩AbleBMI: Bool = false
    @AppStorage("Height") var 🧍HeightValue: Int = 165
    @AppStorage("AbleBodyFat") var 🚩AbleBodyFat: Bool = false
    @AppStorage("AbleDatePicker") var 🚩AbleDatePicker: Bool = false
    
    @Published var 📝MassValue: Double = 65.0
    var 📝BMIValue: Double { 🧮CalculateBMI(📝MassValue, 📏MassUnit, 🧍HeightValue) }
    @Published var 📝BodyFatValue: Double = 0.2
    
    @Published var 💾LastMassSample: HKQuantitySample? = nil
    @Published var 💾LastBMISample: HKQuantitySample? = nil
    @Published var 💾LastBodyFatSample: HKQuantitySample? = nil
    
    @Published var 📅PickerValue = Date.now
    var 🚩DatePickerIsAlmostNow: Bool { 📅PickerValue.timeIntervalSinceNow > -300 }
    
    @Published var 🚩ShowResult: Bool = false
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
            
            var ⓔntry = 🕘Entry(date: 📅Date, massSample: .init(unit: 📏MassUnit, value: 📝MassValue))
            if 🚩AbleBMI { ⓔntry.bmiValue = 📝BMIValue }
            if 🚩AbleBodyFat { ⓔntry.bodyFatValue = 📝BodyFatValue }
            🕘LocalHistory.addLog(ⓔntry)
            
            🚩ShowResult = true
        } catch {
            DispatchQueue.main.async {
                self.🕘LocalHistory.addLog("Error: " + #function + error.localizedDescription)
                self.🚨RegisterError = true
                self.🚩ShowResult = true
            }
        }
    }
    
    
    func 🏥CheckAuthDenied(_ ⓣype: HKQuantityTypeIdentifier) -> Bool {
        if 🏥HealthStore.authorizationStatus(for: HKQuantityType(ⓣype)) == .sharingDenied {
            🚨RegisterError = true
            🚩ShowResult = true
            self.🕘LocalHistory.addLog("Error: " + #function + ⓣype.rawValue)
            return true
        } else {
            return false
        }
    }
    
    
    func 🏥RequestAuth(_ ⓘdentifier: HKQuantityTypeIdentifier) {
        Task {
            do {
                if try await 🏥CheckShouldRequestAuth(ⓘdentifier) {
                    let ⓣype = HKQuantityType(ⓘdentifier)
                    try await 🏥HealthStore.requestAuthorization(toShare: [ⓣype], read: [ⓣype])
                    if ⓘdentifier == .bodyMass { try await 🏥GetPreferredMassUnit() }
                }
            } catch {
                self.🕘LocalHistory.addLog("Error: " + #function + error.localizedDescription)
            }
        }
    }
    
    
    func 🏥CheckShouldRequestAuth(_ identifier: HKQuantityTypeIdentifier) async throws -> Bool {
        let ⓣype = HKQuantityType(identifier)
        return try await 🏥HealthStore.statusForAuthorizationRequest(toShare: [ⓣype], read: [ⓣype]) == .shouldRequest
    }
    
    
    func 🏥CheckAuthOnLaunch() { //TODO: 実装要検討
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
                    }
                }
            } catch {
                🕘LocalHistory.addLog("Error: " + #function + error.localizedDescription)
            }
        }
    }
    
    
    func 🏥GetLatestValue() { //TODO: 実装
        do {
            let query = HKSampleQuery(sampleType: HKQuantityType(.bodyMass), predicate: nil, limit: 1,
                                      sortDescriptors: [NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)]) { _, samples, _ in
                DispatchQueue.main.async {
                    if let sample = samples?.first as? HKQuantitySample {
                        self.📝MassValue = sample.quantity.doubleValue(for: .gramUnit(with: .kilo))
                        self.💾LastMassSample = sample
                    }
                }
            }
            
            🏥HealthStore.execute(query)
        }
        
        do {
            let query = HKSampleQuery(sampleType: HKQuantityType(.bodyMassIndex), predicate: nil, limit: 1,
                                      sortDescriptors: [NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)]) { _, samples, _ in
                DispatchQueue.main.async {
                    self.💾LastBMISample = samples?.first as? HKQuantitySample
                }
            }
            
            🏥HealthStore.execute(query)
        }
        
        do {
            let query = HKSampleQuery(sampleType: HKQuantityType(.bodyFatPercentage), predicate: nil, limit: 1,
                                      sortDescriptors: [NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)]) { _, samples, _ in
                DispatchQueue.main.async {
                    if let sample = samples?.first as? HKQuantitySample {
                        self.📝BodyFatValue = sample.quantity.doubleValue(for: .percent())
                        self.💾LastBodyFatSample = sample
                    }
                }
            }
            
            🏥HealthStore.execute(query)
        }
    }
    
    
    @MainActor
    func 🗑Cancel() async {
        do {
            🚩Canceled = true
            try await 🏥HealthStore.delete(📦Samples)
            📦Samples = []
            🏥GetLatestValue()
            🕘LocalHistory.modifyCancellation()
            UINotificationFeedbackGenerator().notificationOccurred(.error)
        } catch {
            DispatchQueue.main.async {
                self.🕘LocalHistory.addLog("Error: " + error.localizedDescription)
                self.🚨CancelError = true
            }
        }
    }
    
    
    @MainActor
    func 🏥GetPreferredMassUnit() async throws {
        if let 📏 = try await 🏥HealthStore.preferredUnits(for: [HKQuantityType(.bodyMass)]).first {
            switch 📏.value {
                case .gramUnit(with: .kilo): 📏MassUnit = .kg
                case .pound(): 📏MassUnit = .lbs
                case .stone(): 📏MassUnit = .st
                default: print("🐛")
            }
        }
    }
    
    
    func 🅁eset() {
        🚩ShowResult = false
        🚨RegisterError = false
        🚩Canceled = false
        🚨CancelError = false
        📦Samples = []
        🏥GetLatestValue()
    }
    
    
    init() {
        guard let ⓛastEntry = 🕘LocalHistory.ⓛogs.last?.entry else { return } //FIXME: これだと日付入力変更ずみの分も誤取得してしまう
        if ⓛastEntry.cancellation { return }
        📝MassValue = ⓛastEntry.massSample.value
        if let ⓥalue = ⓛastEntry.bodyFatValue {
            📝BodyFatValue = ⓥalue
        }
    }
}


func 🧮CalculateBMI(_ massValue: Double, _ massUnit: 📏BodyMassUnit, _ heightValue: Int) -> Double {
    let ⓠuantity = HKQuantity(unit: massUnit.hkunit, doubleValue: massValue)
    let ⓚiloMassValue = ⓠuantity.doubleValue(for: .gramUnit(with: .kilo))
    let ⓥalue = ⓚiloMassValue / pow(Double(heightValue)/100, 2)
    return Double(Int(round(ⓥalue*10)))/10
}
