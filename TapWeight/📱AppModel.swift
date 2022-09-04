
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
    var 📝BMIValue: Double {
        let ⓠuantity = HKQuantity(unit: 📏MassUnit.hkunit, doubleValue: 📝MassValue)
        let ⓚiloMassValue = ⓠuantity.doubleValue(for: .gramUnit(with: .kilo))
        let 📝 = ⓚiloMassValue / pow(Double(🧍HeightValue)/100, 2)
        return Double(Int(round(📝*10)))/10
    }
    @Published var 📝BodyFatValue: Double = 0.2
    
    @Published var 💾LastMassValue: Double? = nil
    @Published var 💾LastBMIValue: Double? = nil
    @Published var 💾LastBodyFatValue: Double? = nil
    
    @Published var 📅PickerValue = Date.now
    
    @Published var 🚩ShowResult: Bool = false
    @Published var 🚨RegisterError: Bool = false
    @Published var 🚩Canceled: Bool = false
    @Published var 🚨CancelError: Bool = false
    
    @Published var 🕘LocalHistory = 🕘LocalHistoryModel()
    
    let 🏥HealthStore = HKHealthStore()
    
    var 📦Sample: [HKQuantitySample] = []
    
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
        
        📦Sample.append(HKQuantitySample(type: HKQuantityType(.bodyMass),
                                         quantity: HKQuantity(unit: 📏MassUnit.hkunit, doubleValue: 📝MassValue),
                                         start: 📅Date, end: 📅Date))
        
        if 🚩AbleBMI {
            📦Sample.append(HKQuantitySample(type: HKQuantityType(.bodyMassIndex),
                                             quantity: HKQuantity(unit: .count(), doubleValue: 📝BMIValue),
                                             start: 📅Date, end: 📅Date))
        }
        
        if 🚩AbleBodyFat {
            📦Sample.append(HKQuantitySample(type: HKQuantityType(.bodyFatPercentage),
                                             quantity: HKQuantity(unit: .percent(), doubleValue: 📝BodyFatValue),
                                             start: 📅Date, end: 📅Date))
        }
        
        
        do {
            try await 🏥HealthStore.save(📦Sample)
            
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
                let ⓣype: HKSampleType = HKQuantityType(ⓘdentifier)
                let 🚩 = try await 🏥HealthStore.statusForAuthorizationRequest(toShare: [ⓣype], read: [ⓣype])
                print(🚩 == .shouldRequest) //TODO: デバッグ後に削除
                print(🚩 == .unknown) //TODO: デバッグ後に削除
                print(🚩 == .unnecessary) //TODO: デバッグ後に削除
                if 🚩 == .shouldRequest {
                    try await 🏥HealthStore.requestAuthorization(toShare: [ⓣype], read: [ⓣype])
                    if ⓘdentifier == .bodyMass { try await 🏥GetPreferredMassUnit() }
                }
            } catch {
                self.🕘LocalHistory.addLog("Error: " + #function + error.localizedDescription)
            }
        }
    }
    
    
    func 🏥CheckAuthOnLaunch() { //TODO: 実装要検討
        Task {
            do {
                var ⓣypes: Set<HKSampleType> = []
                
                do {
                    let ⓣype = HKQuantityType(.bodyMass)
                    if try await 🏥HealthStore.statusForAuthorizationRequest(toShare: [ⓣype], read: [ⓣype]) == .shouldRequest {
                        ⓣypes.insert(ⓣype)
                    }
                }
                
                if 🚩AbleBMI {
                    let ⓣype = HKQuantityType(.bodyMassIndex)
                    if try await 🏥HealthStore.statusForAuthorizationRequest(toShare: [ⓣype], read: [ⓣype]) == .shouldRequest {
                        ⓣypes.insert(ⓣype)
                    }
                }
                
                if 🚩AbleBodyFat {
                    let ⓣype = HKQuantityType(.bodyFatPercentage)
                    if try await 🏥HealthStore.statusForAuthorizationRequest(toShare: [ⓣype], read: [ⓣype]) == .shouldRequest {
                        ⓣypes.insert(ⓣype)
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
                    guard let sample = samples?.first as? HKQuantitySample else { return }
                    print(sample)
                    self.📝MassValue = sample.quantity.doubleValue(for: self.📏MassUnit.hkunit)
                    self.💾LastMassValue = self.📝MassValue
                }
            }
            
            🏥HealthStore.execute(query)
        }
        
        do {
            let query = HKSampleQuery(sampleType: HKQuantityType(.bodyMassIndex), predicate: nil, limit: 1,
                                      sortDescriptors: [NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)]) { _, samples, _ in
                DispatchQueue.main.async {
                    guard let sample = samples?.first as? HKQuantitySample else { return }
                    print(sample)
                    self.💾LastBMIValue = self.📝BMIValue
                }
            }
            
            🏥HealthStore.execute(query)
        }
        
        do {
            let query = HKSampleQuery(sampleType: HKQuantityType(.bodyFatPercentage), predicate: nil, limit: 1,
                                      sortDescriptors: [NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)]) { _, samples, _ in
                DispatchQueue.main.async {
                    guard let sample = samples?.first as? HKQuantitySample else { return }
                    print(sample)
                    self.📝BodyFatValue = sample.quantity.doubleValue(for: .percent())
                    self.💾LastBodyFatValue = self.📝BodyFatValue
                }
            }
            
            🏥HealthStore.execute(query)
        }
    }
    
    
    @MainActor
    func 🗑Cancel() async {
        do {
            🚩Canceled = true
            try await 🏥HealthStore.delete(📦Sample)
            📦Sample = []
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
        📦Sample = []
        🏥GetLatestValue()
    }
}
