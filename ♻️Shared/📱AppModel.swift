import SwiftUI
import HealthKit

@MainActor
class 📱AppModel: NSObject, ObservableObject {
    //MARK: Stored property
    @AppStorage("Amount50g") var 🚩amount50g: Bool = false
    @AppStorage("AbleBMI") var 🚩ableBMI: Bool = false
    @AppStorage("AbleBodyFat") var 🚩ableBodyFat: Bool = false
    @AppStorage("AbleLBM") var 🚩ableLBM: Bool = false
    @AppStorage("AbleDatePicker") var 🚩ableDatePicker: Bool = false
    @AppStorage("AbleReminder") var 🚩ableReminder: Bool = false
    @AppStorage("BannerNotification") var 🚩ableBannerNotification: Bool = false
    @AppStorage("PeriodOfNonDisplay") var 🔢periodOfNonDisplay: Int = 1
    
    @Published var 📝massInputQuantity: HKQuantity? = nil
    @Published var 📝bodyFatInputQuantity: HKQuantity? = nil
    @Published var 📅datePickerValue: Date = .now
    
    @Published var 📦latestSamples: [🏥Category: HKQuantitySample] = [:]
    @Published var 📦preferredUnits: [🏥Category: HKUnit] = [:]
    
    @Published var 🚩showResult: Bool = false
    @Published var 🚩alertRegistrationError: Bool = false
    @Published var 🚩completedCancellation: Bool = false
    @Published var 🚩alertCancellationError: Bool = false
    var 🚨registrationError: 🚨Error? = nil
    var 🚨cancellationError: 🚨Error? = nil
    var 📨registeredSamples: [HKQuantitySample] = []
    
    let 🏥healthStore = 🏥HealthStore()
    
    //MARK: Computed property
    var ⓜassUnit: HKUnit? { self.📦preferredUnits[.bodyMass] }
    private var ⓜassInputValue: Double? {
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
    var ⓜassInputIsValid: Bool {
        self.📝massInputQuantity != nil
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
    private var ⓗeightValue: Double? {
        guard let ⓗeightUnit else { return nil }
        return self.📦latestSamples[.height]?.quantity.doubleValue(for: ⓗeightUnit)
    }
    var ⓗeightQuantityDescription: String? {
        self.📦latestSamples[.height]?.quantity.description
    }
    
    private var ⓑodyFatInputValue: Double? { self.📝bodyFatInputQuantity?.doubleValue(for: .percent()) }
    var ⓑodyFatInputDescription: String {
        if let ⓑodyFatInputValue {
            return (round(ⓑodyFatInputValue * 1000) / 10).description
        } else {
            return "00.0"
        }
    }
    var ⓑodyFatInputIsValid: Bool {
        self.📝bodyFatInputQuantity != nil
    }
    
    private var ⓛbmInputQuantity: HKQuantity? {
        guard let ⓜassInputValue, let ⓜassUnit, let ⓑodyFatInputValue else { return nil }
        let ⓕigure = ⓜassInputValue - (ⓜassInputValue * ⓑodyFatInputValue)
        return HKQuantity(unit: ⓜassUnit,
                          doubleValue: round(ⓕigure * 10) / 10)
    }
    private var ⓛbmInputValue: Double? {
        guard let ⓛbmInputQuantity, let ⓜassUnit else { return nil }
        return ⓛbmInputQuantity.doubleValue(for: ⓜassUnit)
    }
    var ⓛbmInputDescription: String {
        String(format: "%.1f", ⓛbmInputValue ?? 0.0) + " " + (ⓜassUnit?.description ?? "kg")
    }
    
    var ⓓatePickerIsAlmostNow: Bool { self.📅datePickerValue.timeIntervalSinceNow > -300 }
    
    var ⓛatestSampleDate: [🏥Category: Date] {
        self.📦latestSamples.compactMapValues { ⓢample in
            switch 🏥Category(ⓢample.quantityType) {
                case .bodyMass, .bodyMassIndex, .bodyFatPercentage, .leanBodyMass:
                    return ⓢample.startDate
                case .height:
                    return nil
                default:
                    assertionFailure()
                    return nil
            }
        }
    }
    
    var ⓓifference: [🏥Category: 🄳ifference] {
        self.📦latestSamples.compactMapValues { ⓢample in
            guard let ⓒategory = 🏥Category(ⓢample.quantityType) else { return nil }
            let ⓓifferenceValue: Double? = {
                switch ⓒategory {
                    case .bodyMass:
                        guard let ⓜassInputValue, let ⓜassUnit else { return nil }
                        return round((ⓜassInputValue - ⓢample.quantity.doubleValue(for: ⓜassUnit)) * 100) / 100
                    case .bodyMassIndex:
                        guard let ⓑmiInputValue else { return nil }
                        return round((ⓑmiInputValue - ⓢample.quantity.doubleValue(for: .count())) * 10) / 10
                    case .height:
                        return nil
                    case .bodyFatPercentage:
                        guard let ⓑodyFatInputValue else { return nil }
                        return round((ⓑodyFatInputValue - ⓢample.quantity.doubleValue(for: .percent())) * 1000) / 10
                    case .leanBodyMass:
                        guard let ⓛbmInputValue, let ⓜassUnit else { return nil }
                        return round((ⓛbmInputValue - ⓢample.quantity.doubleValue(for: ⓜassUnit)) * 100) / 100
                }
            }()
            guard let ⓓifferenceValue else { return nil }
            let ⓓescription: String = {
                if ⓒategory == .bodyMass, self.🚩amount50g {
                    switch ⓓifferenceValue {
                        case ..<0: return String(format: "%.2f", ⓓifferenceValue)
                        case 0: return " 0.00"
                        default: return "+" + String(format: "%.2f", ⓓifferenceValue)
                    }
                } else {
                    switch ⓓifferenceValue {
                        case ..<0: return ⓓifferenceValue.description
                        case 0: return " 0.0"
                        default: return "+" + ⓓifferenceValue.description
                    }
                }
            }()
            guard let ⓓate = self.ⓛatestSampleDate[ⓒategory] else { return nil }
            return 🄳ifference(valueDescription: ⓓescription, lastSampleDate: ⓓate)
        }
    }
    
    var ⓡesultSummaryDescription: String {
        let ⓜassSample = self.📨registeredSamples.first(where: { 🏥Category($0.quantityType) == .bodyMass })
        var ⓥalue = ⓜassSample?.quantity.description ?? "🐛"
        if let ⓑmiSample = self.📨registeredSamples.first(where: { 🏥Category($0.quantityType) == .bodyMassIndex }) {
            ⓥalue = [ⓥalue, (ⓑmiSample.quantity.doubleValue(for: .count()).formatted())].formatted(.list(type: .and))
        }
        if let ⓑodyFatSample = self.📨registeredSamples.first(where: { 🏥Category($0.quantityType) == .bodyFatPercentage }) {
            ⓥalue += "\n" + ⓑodyFatSample.quantity.description
        }
        if let ⓛbmSample = self.📨registeredSamples.first(where: { 🏥Category($0.quantityType) == .leanBodyMass }) {
            ⓥalue = [ⓥalue, ⓛbmSample.quantity.description].formatted(.list(type: .and))
        }
        return ⓥalue
    }
    
    //MARK: Method
    func 🎚️changeMassValue(_ ⓟattern: 🅂tepperAction) {
        if let ⓜassUnit, var ⓜassInputValue {
            if ⓜassUnit == HKUnit.gramUnit(with: .kilo), self.🚩amount50g {
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
            💥Feedback.light()
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
            💥Feedback.light()
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
                if self.🚩ableLBM {
                    guard let ⓛbmInputQuantity else { throw 🚨Error.noInputValue(.leanBodyMass) }
                    ⓢamples.append(HKQuantitySample(type: HKQuantityType(.leanBodyMass),
                                                    quantity: ⓛbmInputQuantity,
                                                    start: ⓓate, end: ⓓate))
                }
                do {
                    try await self.🏥healthStore.api.save(ⓢamples)
                    self.📨registeredSamples = ⓢamples
                    self.🚩showResult = true
                    💥Feedback.success()
                } catch {
                    throw 🚨Error.saveFailure(error.localizedDescription)
                }
            } catch {
                Task { @MainActor in
                    self.🚨registrationError = error as? 🚨Error
                    self.🚩alertRegistrationError = true
                    💥Feedback.error()
                }
            }
        }
    }
    func 🗑cancel() {
        Task { @MainActor in
            do {
                try await self.🏥healthStore.api.delete(self.📨registeredSamples)
                self.🚩completedCancellation = true
                💥Feedback.error()
            } catch {
                Task { @MainActor in
                    self.🚨cancellationError = .deleteFailure(error.localizedDescription)
                    self.🚩alertCancellationError = true
                }
            }
        }
    }
    func ⓒloseResultView() {
        self.🚩showResult = false
        self.ⓒlearStates()
    }
    func ⓒlearStates() {
        self.🚨registrationError = nil
        self.🚩completedCancellation = false
        self.🚨cancellationError = nil
        self.📨registeredSamples = []
        self.📝resetInputValues()
    }
    
    func 📝resetInputValues() {
        if let ⓢample = self.📦latestSamples[.bodyMass] {
            self.📝massInputQuantity = ⓢample.quantity
        }
        if let ⓢample = self.📦latestSamples[.bodyFatPercentage] {
            self.📝bodyFatInputQuantity = ⓢample.quantity
        }
    }
    
    func 📅resetDatePickerValue() {
        self.📅datePickerValue = .now
    }
    
    func ⓡequestAuth(_ ⓒategories: Set<🏥Category>) {
        Task { @MainActor in
            do {
                var ⓡeadCategories: Set<🏥Category> = ⓒategories
                if ⓒategories.contains(.bodyMassIndex) { ⓡeadCategories.insert(.height) }
                let ⓢtatus = try await self.🏥healthStore.statusForAuthorizationRequest(toShare: ⓒategories,
                                                                                        read: ⓡeadCategories)
                if ⓢtatus == .shouldRequest {
                    try await self.🏥healthStore.requestAuthorization(toShare: ⓒategories,
                                                                      read: ⓡeadCategories)
                    await self.ⓛoadLatestSamples()
                    await self.ⓛoadPreferredUnits()
                }
            } catch {
                print("🚨", error.localizedDescription)
            }
        }
    }
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
    func ⓛoadLatestSamples() async {
#if os(iOS)
        for ⓒategory: 🏥Category in [.bodyMass, .bodyMassIndex, .height, .bodyFatPercentage, .leanBodyMass] {
            let ⓢample = await self.🏥healthStore.ⓛoadLatestSample(ⓒategory)
            if ⓢample != self.📦latestSamples[ⓒategory] {
                self.📦latestSamples[ⓒategory] = ⓢample
                self.📝resetInputValues()
            }
            self.ⓢetTemporaryQuantity(ⓒategory, condition: ⓢample == nil)
        }
#elseif os(watchOS)
        if let ⓡeceivedContext {
            self.📦latestSamples = ⓡeceivedContext.latestHKQuantitySamples
            self.📝resetInputValues()
        }
#endif
    }
    func ⓞbserveHealthKitChanges() {
#if os(iOS)
        for ⓒategory: 🏥Category in [.bodyMass, .bodyMassIndex, .height, .bodyFatPercentage, .leanBodyMass] {
            self.🏥healthStore.ⓞbserveChange(ⓒategory) { ⓑackgroundObserverCompletionHandler in
                Task { @MainActor in
                    await self.ⓛoadLatestSamples()
                    await self.ⓛoadPreferredUnits()
                    self.ⓒontext.set()
                    if ⓒategory == .bodyMass {
                        await self.🔔refreshNotification()
                        ⓑackgroundObserverCompletionHandler()
                    }
                }
            }
        }
#elseif os(watchOS)
        for ⓒategory: 🏥Category in [.bodyMass, .height] {
            self.🏥healthStore.ⓞbserveChange(ⓒategory) { _ in
                Task { @MainActor in
                    await self.ⓛoadPreferredUnits()
                }
            }
        }
#endif
    }
}

enum 🅂tepperAction {
    case increment, decrement
}

struct 🄳ifference {
    var valueDescription: String
    var lastSampleDate: Date
}

enum 🚨Error: Error {
    case failedAuth(🏥Category)
    case noInputValue(🏥Category)
    case saveFailure(String)
    case deleteFailure(String)
    var message: String {
        switch self {
            case .failedAuth(let ⓒategory):
                let ⓜessage = String(localized: "Authorization error: ")
                return ⓜessage + ⓒategory.localizedString
            case .noInputValue(let ⓒategory):
                let ⓜessage = String(localized: "No input value: ")
                return ⓜessage + ⓒategory.localizedString
            case .saveFailure(let ⓓescription):
                return String(localized: "Save error: \(ⓓescription)")
            case .deleteFailure(let ⓓescription):
                return String(localized: "Delete error: \(ⓓescription)")
        }
    }
}
