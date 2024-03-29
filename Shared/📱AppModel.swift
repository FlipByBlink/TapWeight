import SwiftUI
import HealthKit

@MainActor
class 📱AppModel: NSObject, ObservableObject {
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
}

extension 📱AppModel {
    //MARK: - Computed property
    var ⓜassUnit: HKUnit? { self.📦preferredUnits[.bodyMass] }
    var ⓜassUnitDescription: String? {
        switch self.ⓜassUnit {
            case .some(.gramUnit(with: .kilo)): "kg"
            case .some(.pound()): "lbs"
            case .some(.stone()): "st"
            default: nil
        }
    }
    private var ⓜassInputValue: Double? {
        guard let ⓜassUnit else { return nil }
        return self.📝massInputQuantity?.doubleValue(for: ⓜassUnit)
    }
    var ⓜassInputDescription: String {
        if let ⓜassInputValue {
            if ⓜassUnit == .gramUnit(with: .kilo), self.🚩amount50g {
                🔢NumberFormatter.string(ⓜassInputValue, minimumDigits: 2)
            } else {
                🔢NumberFormatter.string(ⓜassInputValue)
            }
        } else {
            self.🚩amount50g ? "00.00" : "00.0" //Placeholder
        }
    }
    
    var ⓑmiInputValue: Double? {
        guard let 📝massInputQuantity else { return nil }
        let ⓚiloMassValue = 📝massInputQuantity.doubleValue(for: .gramUnit(with: .kilo))
        guard let ⓗeightSample = self.📦latestSamples[.height] else { return nil }
        let ⓗeightMeterValue = ⓗeightSample.quantity.doubleValue(for: .meter())
        let ⓢum = ⓚiloMassValue / pow(ⓗeightMeterValue, 2)
        return Double(Int(round(ⓢum * 10))) / 10
    }
    var ⓑmiInputDescription: String? {
        guard let ⓑmiInputValue else { return nil }
        return 🔢NumberFormatter.string(ⓑmiInputValue)
    }
    var ⓗeightUnit: HKUnit? { self.📦preferredUnits[.height] }
    private var ⓗeightValue: Double? {
        guard let ⓗeightUnit else { return nil }
        return self.📦latestSamples[.height]?.quantity.doubleValue(for: ⓗeightUnit)
    }
    var ⓗeightDescription: String? {
        guard let ⓗeightValue, let ⓗeightUnit else { return nil }
        return ⓗeightValue.formatted() + ⓗeightUnit.description
        //self.📦latestSamples[.height]?.quantity.description ← buggy on watchApp.
    }
    
    private var ⓑodyFatInputValue: Double? { self.📝bodyFatInputQuantity?.doubleValue(for: .percent()) }
    var ⓑodyFatInputDescription: String {
        if let ⓑodyFatInputValue {
            🔢NumberFormatter.string(round(ⓑodyFatInputValue * 1000) / 10)
        } else {
            "00.0"
        }
    }
    
    private var ⓛbmInputQuantity: HKQuantity? {
        guard let ⓜassInputValue, let ⓜassUnit, let ⓑodyFatInputValue else { return nil }
        let ⓢum = ⓜassInputValue - (ⓜassInputValue * ⓑodyFatInputValue)
        return HKQuantity(unit: ⓜassUnit, doubleValue: round(ⓢum * 10) / 10)
    }
    private var ⓛbmInputValue: Double? {
        guard let ⓛbmInputQuantity, let ⓜassUnit else { return nil }
        return ⓛbmInputQuantity.doubleValue(for: ⓜassUnit)
    }
    var ⓛbmInputDescription: String {
        🔢NumberFormatter.string(ⓛbmInputValue ?? 0.0) + " " + (self.ⓜassUnitDescription ?? "kg")
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
    
    var ⓓifference: [🏥Category: 📉Difference] {
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
                        case ..<0: 🔢NumberFormatter.string(ⓓifferenceValue, minimumDigits: 2)
                        case 0: " " + 🔢NumberFormatter.string(0.0, minimumDigits: 2)
                        default: "+" + 🔢NumberFormatter.string(ⓓifferenceValue, minimumDigits: 2)
                    }
                } else {
                    switch ⓓifferenceValue {
                        case ..<0: 🔢NumberFormatter.string(ⓓifferenceValue)
                        case 0: " " + 🔢NumberFormatter.string(0.0)
                        default: "+" + 🔢NumberFormatter.string(ⓓifferenceValue)
                    }
                }
            }()
            guard let ⓓate = self.ⓛatestSampleDate[ⓒategory] else { return nil }
            return 📉Difference(valueDescription: ⓓescription, lastSampleDate: ⓓate)
        }
    }
    
    var ⓡesultSummaryDescription: String {
        let ⓜassSample = self.📨registeredSamples.first(where: { 🏥Category($0.quantityType) == .bodyMass })
        guard let ⓜassSample, let ⓜassUnit, let ⓜassUnitDescription else { return "🐛" }
        var ⓥalue = ⓜassSample.quantity.doubleValue(for: ⓜassUnit).formatted() + ⓜassUnitDescription
        if let ⓑmiSample = self.📨registeredSamples.first(where: { 🏥Category($0.quantityType) == .bodyMassIndex }) {
            ⓥalue = [ⓥalue, (ⓑmiSample.quantity.doubleValue(for: .count()).formatted())].formatted(.list(type: .and))
        }
        if let ⓑodyFatSample = self.📨registeredSamples.first(where: { 🏥Category($0.quantityType) == .bodyFatPercentage }) {
            ⓥalue += "\n" + ⓑodyFatSample.quantity.doubleValue(for: .percent()).formatted(.percent)
        }
        if let ⓛbmSample = self.📨registeredSamples.first(where: { 🏥Category($0.quantityType) == .leanBodyMass }) {
            let ⓛbmDescription = ⓛbmSample.quantity.doubleValue(for: ⓜassUnit).formatted() + ⓜassUnitDescription
            ⓥalue = [ⓥalue, ⓛbmDescription].formatted(.list(type: .and))
        }
        return ⓥalue
    }
    
    //MARK: - Method
    func 🎚️changeMassValue(_ ⓟattern: 🎚️StepperAction) {
        if let ⓜassUnit, var ⓜassInputValue {
            if ⓜassUnit == .gramUnit(with: .kilo), self.🚩amount50g {
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
    func 🎚️changeBodyFatValue(_ ⓟattern: 🎚️StepperAction) {
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
    func ⓢuggestAuthRequest(toShare ⓢhareSuggestions: Set<🏥Category>, read ⓡeadSuggestions: Set<🏥Category>) {
        let ⓢhareCategories = ⓢhareSuggestions.filter { self.🏥healthStore.authorizationStatus(for: $0) == .notDetermined }
        let ⓡeadCategories = ⓡeadSuggestions.filter { self.🏥healthStore.authorizationStatus(for: $0) == .notDetermined }
        if !ⓢhareCategories.isEmpty || !ⓡeadCategories.isEmpty {
            Task { @MainActor in
                do {
                    try await self.🏥healthStore.requestAuthorization(toShare: ⓢhareCategories,
                                                                      read: ⓡeadCategories)
                    await self.ⓛoadPreferredUnits()
                    await self.ⓛoadLatestSamples()
                } catch {
                    print("🚨", error.localizedDescription)
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
        self.ⓐpplyStoredContext()
#endif
    }
    func ⓞbserveHealthKitChanges() {
#if os(iOS)
        self.🏥healthStore.enableBackgroundDelivery(for: [.bodyMass, .height, .bodyFatPercentage])
        for ⓒategory: 🏥Category in [.bodyMass, .bodyMassIndex, .height, .bodyFatPercentage, .leanBodyMass] {
            self.🏥healthStore.ⓞbserveChange(ⓒategory) { ⓑackgroundObserverCompletionHandler in
                Task { @MainActor in
                    await self.ⓛoadPreferredUnits()
                    await self.ⓛoadLatestSamples()
                    if ⓒategory == .bodyMass {
                        await self.🔔refreshNotification()
                    }
                    switch ⓒategory {
                        case .bodyMass, .height, .bodyFatPercentage:
                            self.ⓒontext.sendToWatchApp()
                            ⓑackgroundObserverCompletionHandler()
                        default:
                            break
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
