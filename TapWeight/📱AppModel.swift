import SwiftUI
import HealthKit

class 📱AppModel: ObservableObject {
    @AppStorage("Unit") var 📏massUnit: 📏BodyMassUnit = .kg
    @AppStorage("Amount50g") var 🚩amount50g: Bool = false
    @AppStorage("AbleBMI") var 🚩ableBMI: Bool = false
    @AppStorage("Height") var 🧍heightValue: Int = 165
    @AppStorage("AbleBodyFat") var 🚩ableBodyFat: Bool = false
    @AppStorage("AbleDatePicker") var 🚩ableDatePicker: Bool = false
    
    @Published var 📝massValue: Double = 65.0
    var 📝bmiValue: Double {
        let ⓠuantity = HKQuantity(unit: self.📏massUnit.hkunit, doubleValue: self.📝massValue)
        let ⓚiloMassValue = ⓠuantity.doubleValue(for: .gramUnit(with: .kilo))
        let ⓥalue = ⓚiloMassValue / pow(Double(self.🧍heightValue)/100, 2)
        return Double(Int(round(ⓥalue * 10))) / 10
    }
    @Published var 📝bodyFatValue: Double = 0.2
    
    @Published var 💾lastSamples: [HKQuantityTypeIdentifier: HKQuantitySample] = [:]
    
    @Published var 📅pickerValue: Date = .now
    var 🚩datePickerIsAlmostNow: Bool { self.📅pickerValue.timeIntervalSinceNow > -300 }
    
    @Published var 🚨registerError: Bool = false
    @Published var 🚩canceled: Bool = false
    @Published var 🚨cancelError: Bool = false
    
    @Published var 🕘localHistory = 🕘LocalHistoryModel()
    
    let 🏥healthStore = HKHealthStore()
    var 📦samples: [HKQuantitySample] = []
    
    @MainActor
    func 👆register() async {
        UINotificationFeedbackGenerator().notificationOccurred(.success)
        if self.🏥checkAuthDenied(.bodyMass) { return }
        if self.🚩ableBMI {
            if self.🏥checkAuthDenied(.bodyMassIndex) { return }
        }
        if self.🚩ableBodyFat {
            if self.🏥checkAuthDenied(.bodyFatPercentage) { return }
        }
        let ⓓate: Date = self.🚩ableDatePicker ? self.📅pickerValue : .now
        self.📦samples.append(HKQuantitySample(type: HKQuantityType(.bodyMass),
                                               quantity: HKQuantity(unit: self.📏massUnit.hkunit,
                                                                    doubleValue: self.📝massValue),
                                               start: ⓓate, end: ⓓate))
        if self.🚩ableBMI {
            self.📦samples.append(HKQuantitySample(type: HKQuantityType(.bodyMassIndex),
                                                   quantity: HKQuantity(unit: .count(),
                                                                        doubleValue: self.📝bmiValue),
                                                   start: ⓓate, end: ⓓate))
        }
        if self.🚩ableBodyFat {
            self.📦samples.append(HKQuantitySample(type: HKQuantityType(.bodyFatPercentage),
                                                   quantity: HKQuantity(unit: .percent(),
                                                                        doubleValue: self.📝bodyFatValue),
                                                   start: ⓓate, end: ⓓate))
        }
        do {
            try await self.🏥healthStore.save(self.📦samples)
            self.🕘saveLogForLocalHistory(ⓓate)
        } catch {
            self.🕘localHistory.addLog("Error: " + #function + error.localizedDescription)
            self.🚨registerError = true
        }
    }
    
    func 🏥checkAuthDenied(_ ⓣype: HKQuantityTypeIdentifier) -> Bool {
        if self.🏥healthStore.authorizationStatus(for: HKQuantityType(ⓣype)) == .sharingDenied {
            self.🚨registerError = true
            self.🕘localHistory.addLog("Error: " + #function + ⓣype.rawValue)
            return true
        } else {
            return false
        }
    }
    
    func 🏥checkShouldRequestAuth(_ identifier: HKQuantityTypeIdentifier) async throws -> Bool {
        let ⓣype = HKQuantityType(identifier)
        return try await self.🏥healthStore.statusForAuthorizationRequest(toShare: [ⓣype], read: [ⓣype]) == .shouldRequest
    }
    
    func 🏥requestAuth(_ ⓘdentifier: HKQuantityTypeIdentifier) {
        Task {
            do {
                if try await self.🏥checkShouldRequestAuth(ⓘdentifier) {
                    let ⓣype = HKQuantityType(ⓘdentifier)
                    try await self.🏥healthStore.requestAuthorization(toShare: [ⓣype], read: [ⓣype])
                    self.🏥getLatestValue()
                }
            } catch {
                self.🕘localHistory.addLog("Error: " + #function + error.localizedDescription)
            }
        }
    }
    
    func 🏥checkAuthOnLaunch() {
        Task {
            do {
                var ⓣypes: Set<HKSampleType> = []
                if try await self.🏥checkShouldRequestAuth(.bodyMass) {
                    ⓣypes.insert(HKQuantityType(.bodyMass))
                }
                if self.🚩ableBMI {
                    if try await self.🏥checkShouldRequestAuth(.bodyMassIndex) {
                        ⓣypes.insert(HKQuantityType(.bodyMassIndex))
                    }
                }
                if self.🚩ableBodyFat {
                    if try await self.🏥checkShouldRequestAuth(.bodyFatPercentage) {
                        ⓣypes.insert(HKQuantityType(.bodyFatPercentage))
                    }
                }
                if !ⓣypes.isEmpty {
                    if try await self.🏥healthStore.statusForAuthorizationRequest(toShare: ⓣypes, read: ⓣypes) == .shouldRequest {
                        try await self.🏥healthStore.requestAuthorization(toShare: ⓣypes, read: ⓣypes)
                        if ⓣypes.contains(HKQuantityType(.bodyMass)) { try await self.🏥getPreferredMassUnit() }
                        self.🏥getLatestValue()
                    }
                }
            } catch {
                self.🕘localHistory.addLog("Error: " + #function + error.localizedDescription)
            }
        }
    }
    
    func 🏥getLatestValue() {
        let ⓘdentifiers: [HKQuantityTypeIdentifier] = [.bodyMass, .bodyMassIndex, .bodyFatPercentage]
        for ⓘdentifier in ⓘdentifiers {
            let ⓠuery = HKSampleQuery(sampleType: HKQuantityType(ⓘdentifier),
                                      predicate: nil,
                                      limit: 1,
                                      sortDescriptors: [NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)]) { _, ⓢamples, _ in
                Task { @MainActor in
                    if let ⓢample = ⓢamples?.first as? HKQuantitySample {
                        switch ⓘdentifier {
                            case .bodyMass:
                                let ⓥalue = ⓢample.quantity.doubleValue(for: self.📏massUnit.hkunit)
                                if self.🚩amount50g {
                                    self.📝massValue = round(ⓥalue * 20) / 20
                                } else {
                                    self.📝massValue = round(ⓥalue * 10) / 10
                                }
                                self.💾lastSamples[.bodyMass] = ⓢample
                            case .bodyMassIndex:
                                self.💾lastSamples[.bodyMassIndex] = ⓢample
                            case .bodyFatPercentage:
                                self.📝bodyFatValue = ⓢample.quantity.doubleValue(for: .percent())
                                self.💾lastSamples[.bodyFatPercentage] = ⓢample
                            default:
                                print("🐛")
                        }
                    }
                }
            }
            self.🏥healthStore.execute(ⓠuery)
        }
    }
    
    @MainActor
    func 🗑cancel() {
        Task {
            do {
                self.🚩canceled = true
                try await self.🏥healthStore.delete(self.📦samples)
                self.🏥getLatestValue()
                self.🕘localHistory.modifyCancellation()
                UINotificationFeedbackGenerator().notificationOccurred(.error)
            } catch {
                self.🕘localHistory.addLog("Error: " + error.localizedDescription)
                self.🚨cancelError = true
            }
        }
    }
    
    @MainActor
    func 🏥getPreferredMassUnit() async throws {
        if let 📏 = try await self.🏥healthStore.preferredUnits(for: [HKQuantityType(.bodyMass)]).first {
            switch 📏.value {
                case .gramUnit(with: .kilo):
                    self.📏massUnit = .kg
                    self.📝massValue = 60
                case .pound():
                    self.📏massUnit = .lbs
                    self.📝massValue = 130
                case .stone():
                    self.📏massUnit = .st
                    self.📝massValue = 10
                default:
                    print("🐛")
            }
        }
    }
    
    func ⓡeset() {
        self.🚨registerError = false
        self.🚩canceled = false
        self.🚨cancelError = false
        self.📦samples = []
        self.🏥getLatestValue()
    }
    
    func 🕘saveLogForLocalHistory(_ ⓓate: Date) {
        var ⓔntry = 🕘Entry(date: ⓓate,
                            massSample: .init(unit: self.📏massUnit,
                                              value: self.📝massValue))
        if self.🚩ableBMI { ⓔntry.bmiValue = self.📝bmiValue }
        if self.🚩ableBodyFat { ⓔntry.bodyFatValue = self.📝bodyFatValue }
        self.🕘localHistory.addLog(ⓔntry)
    }
    
    func 🕘loadLastValueFromLocalHistoryOnLaunch() {
        let ⓔntrys = self.🕘localHistory.ⓛogs.compactMap { $0.entry }
        let ⓔntry = ⓔntrys.max { $0.date < $1.date }
        guard let ⓛastEntry = ⓔntry else { return }
        if ⓛastEntry.cancellation { return }
        self.📝massValue = ⓛastEntry.massSample.value
        if let ⓥalue = ⓛastEntry.bodyFatValue {
            self.📝bodyFatValue = ⓥalue
        }
    }
    
    init() {
        self.🕘loadLastValueFromLocalHistoryOnLaunch()
    }
}
