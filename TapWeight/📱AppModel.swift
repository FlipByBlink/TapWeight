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
    
    @Published var 📦latestSamples: [🏥Category: HKQuantitySample] = [:]
    @Published var 📦preferredUnits: [🏥Category: HKUnit] = [:]
    
    @Published var 🚩showResult: Bool = false
    @Published var 🚩alertRegistrationError: Bool = false
    @Published var 🚨registrationError: 🚨Error? = nil
    @Published var 🚩canceled: Bool = false
    @Published var 🚩alertCancellationError: Bool = false
    @Published var 🚨cancellationError: 🚨Error? = nil
    var 📨registeredSamples: [HKQuantitySample] = []
    
    private let 🏥healthStore = 🏥HealthStore()
    
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
    
    var ⓓifferenceDescriptions: [🏥Category: String] {
        self.📦latestSamples.compactMapValues { ⓢample in
            var 📉difference: Double
            switch ⓢample.sampleType {
                case HKQuantityType(.bodyMass):
                    guard let ⓜassInputValue, let ⓜassUnit else { return nil }
                    📉difference = round((ⓜassInputValue - ⓢample.quantity.doubleValue(for: ⓜassUnit)) * 100) / 100
                    if self.🚩amount50g {
                        switch 📉difference {
                            case ..<0: return String(format: "%.2f", 📉difference)
                            case 0: return "0.00"
                            default: return "+" + String(format: "%.2f", 📉difference)
                        }
                    }
                case HKQuantityType(.bodyMassIndex):
                    guard let ⓑmiInputValue else { return nil }
                    📉difference = round((ⓑmiInputValue - ⓢample.quantity.doubleValue(for: .count())) * 10) / 10
                case HKQuantityType(.bodyFatPercentage):
                    guard let ⓑodyFatInputValue else { return nil }
                    📉difference = round((ⓑodyFatInputValue - ⓢample.quantity.doubleValue(for: .percent())) * 1000) / 10
                default:
                    return nil
            }
            switch 📉difference {
                case ..<0: return 📉difference.description
                case 0: return "0.0"
                default: return "+" + 📉difference.description
            }
        }
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
    
    private var ⓣemporaryMassQuantity: HKQuantity {
        if let ⓜassUnit {
            switch ⓜassUnit {
                case .gramUnit(with: .kilo): return HKQuantity(unit: ⓜassUnit, doubleValue: 60.0)
                case .pound(): return HKQuantity(unit: ⓜassUnit, doubleValue: 130.0)
                case .stone(): return HKQuantity(unit: ⓜassUnit, doubleValue: 10.0)
                default: return HKQuantity(unit: ⓜassUnit, doubleValue: 0.0)
            }
        } else {
            return HKQuantity(unit: .gramUnit(with: .kilo), doubleValue: 0.0)
        }
    }
    
    //MARK: Method
    func ⓢetupOnLaunch() {
        self.ⓡequestAuth(.bodyMass)
        self.ⓞbserveChanges()
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
                var ⓒategories: [🏥Category] = [.bodyMass]
                if self.🚩ableBMI { ⓒategories.append(.bodyMassIndex) }
                if self.🚩ableBodyFat { ⓒategories.append(.bodyFatPercentage) }
                for ⓒategory in ⓒategories {
                    guard self.🏥healthStore.authorizationStatus(for: ⓒategory) == .sharingAuthorized else {
                        throw 🚨Error.failedAuth(ⓒategory)
                    }
                }
                var ⓢamples: [HKQuantitySample] = []
                let ⓓate: Date = self.🚩ableDatePicker ? self.📅datePickerValue : .now
                guard let 📝massInputQuantity else { throw 🚨Error.noInputValue(.bodyMass) }
                ⓢamples.append(HKQuantitySample(type: HKQuantityType(.bodyMass),
                                                quantity: 📝massInputQuantity,
                                                start: ⓓate, end: ⓓate))
                if self.🚩ableBMI {
                    guard let ⓑmiInputValue else { throw 🚨Error.noInputValue(.bodyMassIndex) }
                    ⓢamples.append(HKQuantitySample(type: HKQuantityType(.bodyMassIndex),
                                                    quantity: HKQuantity(unit: .count(),
                                                                         doubleValue: ⓑmiInputValue),
                                                    start: ⓓate, end: ⓓate))
                }
                if self.🚩ableBodyFat {
                    guard let 📝bodyFatInputQuantity else { throw 🚨Error.noInputValue(.bodyFatPercentage) }
                    ⓢamples.append(HKQuantitySample(type: HKQuantityType(.bodyFatPercentage),
                                                    quantity: 📝bodyFatInputQuantity,
                                                    start: ⓓate, end: ⓓate))
                }
                do {
                    try await self.🏥healthStore.save(ⓢamples)
                    self.📨registeredSamples = ⓢamples
                    self.🚩showResult = true
                    UINotificationFeedbackGenerator().notificationOccurred(.success)
                } catch {
                    throw 🚨Error.saveFailure(error.localizedDescription)
                }
            } catch {
                Task { @MainActor in
                    self.🚨registrationError = error as? 🚨Error
                    self.🚩alertRegistrationError = true
                    UINotificationFeedbackGenerator().notificationOccurred(.error)
                }
            }
        }
    }
    @MainActor
    func 🗑cancel() {
        Task {
            do {
                try await self.🏥healthStore.delete(self.📨registeredSamples)
                self.🚩canceled = true
                UINotificationFeedbackGenerator().notificationOccurred(.error)
            } catch {
                Task { @MainActor in
                    self.🚨cancellationError = .deleteFailure(error.localizedDescription)
                    self.🚩alertCancellationError = true
                }
            }
        }
    }
    @MainActor
    func ⓡesetAppState() {
        self.🚩showResult = false
        self.🚨registrationError = nil
        self.🚩canceled = false
        self.🚨cancellationError = nil
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
    
    func ⓡequestAuth(_ ⓒategory: 🏥Category) {
        Task {
            do {
                var ⓡeadCategories: Set<🏥Category> = [ⓒategory]
                if ⓒategory == .bodyMassIndex { ⓡeadCategories.insert(.height) }
                let ⓢtatus = try await self.🏥healthStore.statusForAuthorizationRequest(toShare: [ⓒategory],
                                                                                        read: ⓡeadCategories)
                if ⓢtatus == .shouldRequest {
                    try await self.🏥healthStore.requestAuthorization(toShare: [ⓒategory],
                                                                      read: ⓡeadCategories)
                    self.ⓛoadLatestSamples()
                    await self.ⓛoadPreferredUnits()
                }
            } catch {
                print("🚨", error.localizedDescription)
            }
        }
    }
    private func ⓛoadLatestSamples() {
        self.🏥healthStore.ⓛoadLatestSamples { ⓒategory, ⓢamples in
            Task { @MainActor in
                self.📦latestSamples[ⓒategory] = ⓢamples.first as? HKQuantitySample
                self.📝resetInputValues()
                if ⓢamples.isEmpty {
                    switch ⓒategory {
                        case .bodyMass:
                            self.📝massInputQuantity = self.ⓣemporaryMassQuantity
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
    private func ⓛoadPreferredUnits() async {
        for ⓒategory: 🏥Category in [.bodyMass, .height] {
            if let ⓤnit = try? await self.🏥healthStore.preferredUnit(for: ⓒategory) {
                if self.📦preferredUnits[ⓒategory] != ⓤnit {
                    self.📦preferredUnits[ⓒategory] = ⓤnit
                    self.📝resetInputValues()
                }
            }
        }
    }
    private func ⓞbserveChanges() {
        self.🏥healthStore.ⓞbserveChanges { ⓒompletionHandler in
            Task { @MainActor in
                self.ⓛoadLatestSamples()
                await self.ⓛoadPreferredUnits()
                ⓒompletionHandler()
            }
        }
    }
}

enum 🅂tepperAction {
    case increment, decrement
}

enum 🚨Error: Error {
    case failedAuth(🏥Category)
    case noInputValue(🏥Category)
    case saveFailure(String)
    case deleteFailure(String)
    var message: String {
        switch self {
            case .failedAuth(let ⓒategory):
                return "Fail auth for " + String(localized: ⓒategory.description)
            case .noInputValue(let ⓒategory):
                return "No value: " + String(localized: ⓒategory.description)
            case .saveFailure(let ⓓescription):
                return "Failed to save: \(ⓓescription)"
            case .deleteFailure(let ⓓescription):
                return "Failed to delete: \(ⓓescription)"
        }
    }
}
