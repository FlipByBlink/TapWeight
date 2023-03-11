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
    
    private let 🏥healthStore = 🏥HealthStore()
    
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
                        case 0: return "0.00"
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
    
    var ⓡesultSummaryDescription: String? {
        self.📨registeredSamples.reduce("") { ⓓescription, ⓢample in
            switch 🏥Category(ⓢample.quantityType) {
                case .bodyMass:
                    return ⓓescription + ⓢample.quantity.description
                case .bodyMassIndex:
                    return ⓓescription +  " / " + ⓢample.quantity.doubleValue(for: .count()).description
                case .height:
                    assertionFailure()
                    return ⓓescription
                case .bodyFatPercentage:
                    return ⓓescription +  " / " + ⓢample.quantity.description
                case .leanBodyMass:
                    return ⓓescription +  " / " + ⓢample.quantity.description
                case .none:
                    assertionFailure()
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
        self.ⓡequestAuth([.bodyMass])
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
                    try await self.🏥healthStore.save(ⓢamples)
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
        Task {
            do {
                try await self.🏥healthStore.delete(self.📨registeredSamples)
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
    
    func ⓡequestAuth(_ ⓒategories: Set<🏥Category>) {
        Task {
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
    private func ⓛoadLatestSamples() async {
        for ⓒategory: 🏥Category in [.bodyMass, .bodyMassIndex, .height, .bodyFatPercentage, .leanBodyMass] {
            let ⓢample = await self.🏥healthStore.ⓛoadLatestSample(ⓒategory)
            self.📦latestSamples[ⓒategory] = ⓢample
            self.📝resetInputValues()
#if os(iOS)
            if ⓢample == nil {
                switch ⓒategory {
                    case .bodyMass:
                        self.📝massInputQuantity = self.ⓣemporaryMassQuantity
                    case .bodyFatPercentage:
                        self.📝bodyFatInputQuantity = HKQuantity(unit: .percent(), doubleValue: 0.2)
                    default:
                        break
                }
            }
#endif
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
    private func ⓞbserveChanges() {
        for ⓒategory: 🏥Category in [.bodyMass, .bodyMassIndex, .height, .bodyFatPercentage, .leanBodyMass] {
            self.🏥healthStore.ⓞbserveChange(ⓒategory) { ⓒompletionHandler in
                Task { @MainActor in
                    await self.ⓛoadLatestSamples()
                    await self.ⓛoadPreferredUnits()
#if os(iOS)
                    if ⓒategory == .bodyMass { self.🔔refreshNotification(ⓒompletionHandler) }
#endif
                }
            }
        }
    }
    
#if os(iOS) //MARK: Notification iOS only
    let 🔔notification = 🔔Notification()
    func 🔔setupNotification() {
        Task {
            try await self.🔔notification.api.requestAuthorization(options: [.badge, .alert, .sound])
            try await self.🏥healthStore.enableBackgroundDelivery(for: .bodyMass)
            self.🔔refreshNotification()
        }
    }
    func 🔔refreshNotification(_ ⓞbserveCompletionHandler: HKObserverQueryCompletionHandler? = nil) {
        //1. 最新の体重データを取得
        //2. 既にセットされていた通知を削除
        //3. 通知をセット(バッジ/バナー)
        //4. (ObserverQueryから実行された場合)HKObserverQueryCompletionHandlerを呼ぶ
        Task { @MainActor in
            let ⓢample = await self.🏥healthStore.ⓛoadLatestSample(.bodyMass)
            self.🔔notification.removeAllNotifications()
            guard let ⓢample, self.🚩ableReminder else {
                ⓞbserveCompletionHandler?()
                return
            }
            let ⓟeriodToNow = Int(ⓢample.startDate.distance(to: .now) / (60 * 60 * 24))
            if ⓟeriodToNow >= self.🔢periodOfNonDisplay {
                self.🔔notification.setBadgeNow(ⓟeriodToNow)
            }
            for ⓒount in self.🔢periodOfNonDisplay...50 {
                let ⓐlertTime = ⓢample.startDate.addingTimeInterval(Double(60 * 60 * 24 * ⓒount))
                let ⓣimeInterval = Date.now.distance(to: ⓐlertTime)
                guard ⓣimeInterval > 0 else { continue }
                let ⓒontent = UNMutableNotificationContent()
                ⓒontent.badge = ⓒount as NSNumber
                if self.🚩ableBannerNotification {
                    ⓒontent.title = "Reminder: \(String(localized: "Body Mass"))"
                    let ⓕormatter = DateComponentsFormatter()
                    ⓕormatter.allowedUnits = [.day]
                    ⓒontent.body = "Passed \(ⓕormatter.string(from: Double(60 * 60 * 24 * ⓒount)) ?? "🐛")."
                    ⓒontent.sound = .default
                }
                let ⓣrigger = UNTimeIntervalNotificationTrigger(timeInterval: ⓣimeInterval, repeats: false)
                let ⓡequest = UNNotificationRequest(identifier: ⓒount.description,
                                                    content: ⓒontent,
                                                    trigger: ⓣrigger)
                try? await self.🔔notification.api.add(ⓡequest)
            }
            ⓞbserveCompletionHandler?()
        }
    }
    func checkAlertAboutAuthDenied() async -> Bool {
        guard self.🚩ableReminder else { return false }
        let ⓢetting = await self.🔔notification.api.notificationSettings()
        return ⓢetting.authorizationStatus == .denied
    }
#endif
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
                return ⓜessage + String(localized: ⓒategory.description)
            case .noInputValue(let ⓒategory):
                let ⓜessage = String(localized: "No input value: ")
                return ⓜessage + String(localized: ⓒategory.description)
            case .saveFailure(let ⓓescription):
                return "Save error: \(ⓓescription)"
            case .deleteFailure(let ⓓescription):
                return "Delete error: \(ⓓescription)"
        }
    }
}
