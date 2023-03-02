import SwiftUI
import HealthKit

class 📱AppModel: ObservableObject {
    //MARK: Stored property
    @AppStorage("Amount50g") var 🚩amount50g: Bool = false
    @AppStorage("AbleBMI") var 🚩ableBMI: Bool = false
    @AppStorage("AbleBodyFat") var 🚩ableBodyFat: Bool = false
    @AppStorage("AbleDatePicker") var 🚩ableDatePicker: Bool = false
    
    @Published var 📝massInputQuantity: HKQuantity? = nil
    @Published var 📝bodyFatInputQuantity: HKQuantity? = nil
    @Published var 📅datePickerValue: Date = .now
    
    @Published var 📦latestSamples: [🏥HealthStore.Category: HKQuantitySample] = [:]
    @Published var 📦preferredUnits: [🏥HealthStore.Category: HKUnit] = [:]
    
    @Published var 🚩showResult: Bool = false
    @Published var 🚨registerationError: 🚨RegistrationError? = nil
    @Published var 🚩canceled: Bool = false
    @Published var 🚨cancelError: Bool = false
    var 📨registeredSamples: [HKQuantitySample] = []
    
    private let 🏥healthStore = HKHealthStore()
    
    private let ⓐpi = 🏥HealthStore()
    
    //MARK: Computed property
    var ⓜassUnit: HKUnit? { self.📦preferredUnits[.bodyMass] }
    var ⓜassInputValue: Double? {
        guard let ⓜassUnit else { return nil }
        return self.📝massInputQuantity?.doubleValue(for: ⓜassUnit)
    }
    var ⓜassInputDescription: String {
        if let ⓜassInputValue {
            return self.🚩amount50g ? String(format: "%.2f", ⓜassInputValue) : ⓜassInputValue.description
        } else {
            return self.🚩amount50g ? "00.00" : "00.0"
        }
    }
    
    var ⓑmiInputValue: Double? {
        guard let 📝massInputQuantity else { return nil }
        let ⓚiloMassValue = 📝massInputQuantity.doubleValue(for: .gramUnit(with: .kilo))
        guard let ⓗeightSample = self.📦latestSamples[.height] else { return nil }
        let ⓗeightValue = ⓗeightSample.quantity.doubleValue(for: .meter())
        let ⓥalue = ⓚiloMassValue / pow(ⓗeightValue, 2)
        return Double(Int(round(ⓥalue * 10))) / 10
    }
    var ⓗeightUnit: HKUnit? { self.📦preferredUnits[.height] }
    var ⓗeightValue: Double? {
        guard let ⓗeightUnit else { return nil }
        return self.📦latestSamples[.height]?.quantity.doubleValue(for: ⓗeightUnit)
    }
    
    var ⓑodyFatInputValue: Double? { self.📝bodyFatInputQuantity?.doubleValue(for: .percent()) }
    var ⓑodyFatInputDescription: String {
        if let ⓑodyFatInputValue {
            return (round(ⓑodyFatInputValue * 1000) / 10).description
        } else {
            return "00.0"
        }
    }
    
    var ⓓatePickerIsAlmostNow: Bool { self.📅datePickerValue.timeIntervalSinceNow > -300 }
    
    var ⓓifferenceDescriptions: [🏥HealthStore.Category: String] {
        var ⓓescriptions: [🏥HealthStore.Category: String] = [:]
        for ⓒategory: 🏥HealthStore.Category in [.bodyMass, .bodyMassIndex, .bodyFatPercentage] {
            let ⓛastSample = self.📦latestSamples[ⓒategory]
            var 📉difference: Double? = nil
            if let 📝lastValue = ⓛastSample?.quantity {
                switch ⓒategory {
                    case .bodyMass:
                        if let ⓤnit = self.📦preferredUnits[ⓒategory] {
                            if let ⓜassInputValue {
                                📉difference = round((ⓜassInputValue - 📝lastValue.doubleValue(for: ⓤnit)) * 100) / 100
                            }
                        }
                    case .bodyMassIndex:
                        if let ⓑmiInputValue {
                            📉difference = round((ⓑmiInputValue - 📝lastValue.doubleValue(for: .count())) * 10) / 10
                        } else {
                            continue
                        }
                    case .bodyFatPercentage:
                        if let ⓑodyFatInputValue {
                            📉difference = round((ⓑodyFatInputValue - 📝lastValue.doubleValue(for: .percent())) * 1000) / 10
                        }
                    default:
                        continue
                }
                if let 📉difference {
                    switch 📉difference {
                        case ..<0:
                            if ⓒategory == .bodyMass && self.🚩amount50g {
                                ⓓescriptions[.bodyMass] = String(format: "%.2f", 📉difference)
                            } else {
                                ⓓescriptions[ⓒategory] = 📉difference.description
                            }
                        case 0:
                            if ⓒategory == .bodyMass && self.🚩amount50g {
                                ⓓescriptions[.bodyMass] = "0.00"
                            } else {
                                ⓓescriptions[ⓒategory] = "0.0"
                            }
                        default:
                            if ⓒategory == .bodyMass && self.🚩amount50g {
                                ⓓescriptions[.bodyMass] = "+" + String(format: "%.2f", 📉difference)
                            } else {
                                ⓓescriptions[ⓒategory] = "+" + 📉difference.description
                            }
                    }
                }
            }
        }
        return ⓓescriptions
    }
    
    var ⓡesultSummaryDescription: String? {
        self.📨registeredSamples.reduce("") { ⓓescription, ⓢample in
            switch ⓢample.quantityType {
                case .init(.bodyMass):
                    return ⓓescription + ⓢample.quantity.description
                case .init(.bodyMassIndex):
                    return ⓓescription +  " / " + ⓢample.quantity.doubleValue(for: .count()).description
                case .init(.bodyFatPercentage):
                    return ⓓescription +  " / " + ⓢample.quantity.description
                default:
                    return ⓓescription
            }
        }
    }
    
    //MARK: Method
    func ⓢetupOnLaunch() {
        self.🏥requestAuth(.bodyMass)
        self.🏥observeChanges()
    }
    
    func 🎚️changeMassValue(_ ⓟattern: 🅂tepperAction) {
        if let ⓜassUnit, var ⓜassInputValue {
            if self.🚩amount50g {
                switch ⓟattern {
                    case .increment: ⓜassInputValue += 0.05
                    case .decrement: ⓜassInputValue -= 0.05
                }
                ⓜassInputValue = round(ⓜassInputValue * 100) / 100
            } else {
                switch ⓟattern {
                    case .increment: ⓜassInputValue += 0.1
                    case .decrement: ⓜassInputValue -= 0.1
                }
                ⓜassInputValue = round(ⓜassInputValue * 10) / 10
            }
            self.📝massInputQuantity = HKQuantity(unit: ⓜassUnit, doubleValue: ⓜassInputValue)
        }
    }
    func 🎚️changeBodyFatValue(_ ⓟattern: 🅂tepperAction) {
        if var ⓑodyFatInputValue {
            switch ⓟattern {
                case .increment: ⓑodyFatInputValue += 0.001
                case .decrement: ⓑodyFatInputValue -= 0.001
            }
            ⓑodyFatInputValue = round(ⓑodyFatInputValue * 1000) / 1000
            self.📝bodyFatInputQuantity = HKQuantity(unit: .percent(), doubleValue: ⓑodyFatInputValue)
        }
    }
    
    func 👆register() { // ☑️
        Task { @MainActor in
            do {
                var ⓘnputTypes: [🄷ealthType] = [.bodyMass]
                if self.🚩ableBMI { ⓘnputTypes.append(.bmi) }
                if self.🚩ableBodyFat { ⓘnputTypes.append(.bodyFat) }
                for ⓣype in ⓘnputTypes {
                    let ⓢtate = self.🏥healthStore.authorizationStatus(for: HKQuantityType(ⓣype.identifier))
                    guard ⓢtate == .sharingAuthorized else {
                        throw 🚨RegistrationError.failedAuth(ⓣype)
                    }
                }
                var ⓢamples: [HKQuantitySample] = []
                let ⓓate: Date = self.🚩ableDatePicker ? self.📅datePickerValue : .now
                guard let 📝massInputQuantity else { throw 🚨RegistrationError.noValue(.bodyMass) }
                ⓢamples.append(HKQuantitySample(type: HKQuantityType(.bodyMass),
                                                quantity: 📝massInputQuantity,
                                                start: ⓓate, end: ⓓate))
                if self.🚩ableBMI {
                    guard let ⓑmiInputValue else { throw 🚨RegistrationError.noValue(.bmi) }
                    ⓢamples.append(HKQuantitySample(type: HKQuantityType(.bodyMassIndex),
                                                    quantity: HKQuantity(unit: .count(),
                                                                         doubleValue: ⓑmiInputValue),
                                                    start: ⓓate, end: ⓓate))
                }
                if self.🚩ableBodyFat {
                    guard let 📝bodyFatInputQuantity else { throw 🚨RegistrationError.noValue(.bodyFat) }
                    ⓢamples.append(HKQuantitySample(type: HKQuantityType(.bodyFatPercentage),
                                                    quantity: 📝bodyFatInputQuantity,
                                                    start: ⓓate, end: ⓓate))
                }
                do {
                    try await self.🏥healthStore.save(ⓢamples)
                } catch {
                    throw 🚨RegistrationError.saveFailure(error.localizedDescription)
                }
                self.📨registeredSamples = ⓢamples
                UINotificationFeedbackGenerator().notificationOccurred(.success)
            } catch {
                self.🚨registerationError = error as? 🚨RegistrationError
                print("🚨", error.localizedDescription)
                UINotificationFeedbackGenerator().notificationOccurred(.error)
            }
            self.🚩showResult = true
        }
    }
    @MainActor
    func 🗑cancel() {
        Task {
            do {
                self.🚩canceled = true
                try await self.🏥healthStore.delete(self.📨registeredSamples)
                UINotificationFeedbackGenerator().notificationOccurred(.error)
            } catch {
                self.🚨cancelError = true
                print("🚨", error.localizedDescription)
            }
        }
    }
    @MainActor
    func ⓡesetAppState() {
        self.🚩showResult = false
        self.🚨registerationError = nil
        self.🚩canceled = false
        self.🚨cancelError = false
        self.📨registeredSamples = []
        self.📝resetInputValues()
    }
    
    @MainActor
    func 📝resetInputValues() {
        if let ⓢample = self.📦latestSamples[.bodyMass] {
            self.📝massInputQuantity = ⓢample.quantity
        }
        if let ⓢample = self.📦latestSamples[.bodyFatPercentage] {
            self.📝bodyFatInputQuantity = ⓢample.quantity
        }
    }
    
    func 🏥requestAuth(_ ⓘdentifier: HKQuantityTypeIdentifier) {
        let ⓢhareType: Set<HKQuantityType> = [HKQuantityType(ⓘdentifier)]
        var ⓡeadTypes: Set<HKQuantityType> {
            if ⓘdentifier == .bodyMassIndex {
                return [HKQuantityType(.bodyMassIndex), HKQuantityType(.height)]
            } else {
                return [HKQuantityType(ⓘdentifier)]
            }
        }
        Task {
            do {
                let ⓢtatus = try await self.🏥healthStore.statusForAuthorizationRequest(toShare: ⓢhareType, read: ⓡeadTypes)
                if ⓢtatus == .shouldRequest {
                    try await self.🏥healthStore.requestAuthorization(toShare: ⓢhareType, read: ⓡeadTypes)
                    self.🏥loadLatestSamples()
                    await self.🏥loadPreferredUnits()
                }
            } catch {
                print("🚨", error.localizedDescription)
            }
        }
    }
    private func 🏥loadLatestSamples() {
        self.ⓐpi.ⓛoadLatestSamples { ⓒategory, ⓢamples in
            Task { @MainActor in
                self.📦latestSamples[ⓒategory] = ⓢamples.first as? HKQuantitySample
                self.📝resetInputValues()
                if ⓢamples.isEmpty {
                    switch ⓒategory {
                        case .bodyMass:
                            if let ⓤnit = self.📦preferredUnits[.bodyMass] {
                                switch ⓤnit {
                                    case .gramUnit(with: .kilo):
                                        self.📝massInputQuantity = HKQuantity(unit: ⓤnit, doubleValue: 60.0)
                                    case .pound():
                                        self.📝massInputQuantity = HKQuantity(unit: ⓤnit, doubleValue: 130.0)
                                    case .stone():
                                        self.📝massInputQuantity = HKQuantity(unit: ⓤnit, doubleValue: 10.0)
                                    default:
                                        break
                                }
                            }
                        case .bodyFatPercentage:
                            self.📝bodyFatInputQuantity = HKQuantity(unit: .percent(), doubleValue: 0.2)
                        default:
                            break
                    }
                }
            }
        }
    }
    @MainActor
    private func 🏥loadPreferredUnits() async {
        for ⓒategory: 🏥HealthStore.Category in [.bodyMass, .height] {
            if let ⓤnit = try? await self.🏥healthStore.preferredUnits(for: [ⓒategory.type]).first?.value {
                if self.📦preferredUnits[ⓒategory] != ⓤnit {
                    self.📦preferredUnits[ⓒategory] = ⓤnit
                    self.📝resetInputValues()
                }
            }
        }
    }
    private func 🏥observeChanges() {
        self.ⓐpi.ⓞbserveChanges { ⓒompletionHandler in
            Task { @MainActor in
                self.🏥loadLatestSamples()
                await self.🏥loadPreferredUnits()
                ⓒompletionHandler()
            }
        }
    }
}

enum 🄷ealthType {
    case bodyMass, bmi, height, bodyFat
    var identifier: HKQuantityTypeIdentifier {
        switch self {
            case .bodyMass: return .bodyMass
            case .bmi: return .bodyMassIndex
            case .height: return .height
            case .bodyFat: return .bodyFatPercentage
        }
    }
    var description: String.LocalizationValue {
        switch self {
            case .bodyMass: return "Body Mass"
            case .bmi: return "Body Mass Index"
            case .height: return "Height"
            case .bodyFat: return "Body Fat Percentage"
        }
    }
}

enum 🅂tepperAction {
    case increment, decrement
}

enum 🚨RegistrationError: Error {
    case failedAuth(🄷ealthType)
    case saveFailure(String)
    case noValue(🄷ealthType)
    var message: String {
        switch self {
            case .failedAuth(let ⓣype):
                return "Fail auth for " + String(localized: ⓣype.description)
            case .saveFailure(let ⓓescription):
                return "Failed to save: \(ⓓescription)"
            case .noValue(let ⓣype):
                return "No value: " + String(localized: ⓣype.description)
        }
    }
}
