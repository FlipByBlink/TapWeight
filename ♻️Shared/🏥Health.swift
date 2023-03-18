import HealthKit
import SwiftUI

struct 🏥HealthStore {
    let api = HKHealthStore()
    
    func authorizationStatus(for ⓒategory: 🏥Category) -> HKAuthorizationStatus {
        self.api.authorizationStatus(for: ⓒategory.quantityType)
    }
    
    func requestAuthorization(toShare ⓣypesToShare: Set<🏥Category>,
                              read ⓣypesToRead: Set<🏥Category>) async throws {
        try await self.api.requestAuthorization(toShare: Set(ⓣypesToShare.map { $0.quantityType }),
                                                read: Set(ⓣypesToRead.map { $0.quantityType }))
    }
    
    func preferredUnit(for ⓒategory: 🏥Category) async throws -> HKUnit? {
        try await self.api.preferredUnits(for: [ⓒategory.quantityType]).first?.value
    }
    
    func enableBackgroundDelivery(for ⓒategories: [🏥Category]) {
        Task {
            for ⓒategory in ⓒategories {
                try? await self.api.enableBackgroundDelivery(for: ⓒategory.quantityType, frequency: .immediate)
            }
        }
    }
    
    func ⓛoadLatestSample(_ ⓒategory: 🏥Category) async -> HKQuantitySample? {
        await withCheckedContinuation { ⓒontinuation in
            let ⓢortDescriptors = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
            let ⓠuery = HKSampleQuery(sampleType: ⓒategory.quantityType,
                                      predicate: nil,
                                      limit: 1,
                                      sortDescriptors: [ⓢortDescriptors]) { _, ⓢamples, ⓔrror in
                if ⓔrror == nil {
                    if let ⓢamples {
                        ⓒontinuation.resume(returning: ⓢamples.first as? HKQuantitySample)
                    } else {
                        assertionFailure()
                        ⓒontinuation.resume(returning: nil)
                    }
                } else {
                    ⓒontinuation.resume(returning: nil)
                }
            }
            self.api.execute(ⓠuery)
        }
    }
    
    func ⓞbserveChange(_ ⓒategory: 🏥Category, _ ⓗandler: @escaping (@escaping HKObserverQueryCompletionHandler) -> Void ) {
        let ⓠuery = HKObserverQuery(sampleType: ⓒategory.quantityType, predicate: nil) { _, ⓒompletionHandler, ⓔrror in
            guard ⓔrror == nil else { return }
            ⓗandler(ⓒompletionHandler)
        }
        self.api.execute(ⓠuery)
    }
    
    //func statusForAuthorizationRequest(toShare ⓣypesToShare: Set<🏥Category>,
    //                                   read ⓣypesToRead: Set<🏥Category>) async throws -> HKAuthorizationRequestStatus {
    //    try await self.api.statusForAuthorizationRequest(toShare: Set(ⓣypesToShare.map { $0.quantityType }),
    //                                                     read: Set(ⓣypesToRead.map { $0.quantityType }))
    //}
}

enum 🏥Category: Codable {
    case bodyMass, bodyMassIndex, height, bodyFatPercentage, leanBodyMass
    var identifier: HKQuantityTypeIdentifier {
        switch self {
            case .bodyMass: return .bodyMass
            case .bodyMassIndex: return .bodyMassIndex
            case .height: return .height
            case .bodyFatPercentage: return .bodyFatPercentage
            case .leanBodyMass: return .leanBodyMass
        }
    }
    var localizationValue: String.LocalizationValue {
        switch self {
            case .bodyMass: return "Body Mass"
            case .bodyMassIndex: return "Body Mass Index"
            case .height: return "Height"
            case .bodyFatPercentage: return "Body Fat Percentage"
            case .leanBodyMass: return "Lean Body Mass"
        }
    }
    var localizedString: String {
        String(localized: self.localizationValue)
    }
    var quantityType: HKQuantityType {
        switch self {
            case .bodyMass: return HKQuantityType(.bodyMass)
            case .bodyMassIndex: return HKQuantityType(.bodyMassIndex)
            case .height: return HKQuantityType(.height)
            case .bodyFatPercentage: return HKQuantityType(.bodyFatPercentage)
            case .leanBodyMass: return HKQuantityType(.leanBodyMass)
        }
    }
    var defaultUnit: HKUnit {
        switch self {
            case .bodyMass: return .gramUnit(with: .kilo)
            case .bodyMassIndex: return .count()
            case .height: return .meter()
            case .bodyFatPercentage: return .percent()
            case .leanBodyMass: return .gramUnit(with: .kilo)
        }
    }
    init?(_ ⓘdentifier: HKQuantityTypeIdentifier) {
        switch ⓘdentifier {
            case .bodyMass: self = .bodyMass
            case .bodyMassIndex: self = .bodyMassIndex
            case .height: self = .height
            case .bodyFatPercentage: self = .bodyFatPercentage
            case .leanBodyMass: self = .leanBodyMass
            default: assertionFailure(); return nil
        }
    }
    init?(_ ⓣype: HKQuantityType) {
        switch ⓣype {
            case HKQuantityType(.bodyMass): self = .bodyMass
            case HKQuantityType(.bodyMassIndex): self = .bodyMassIndex
            case HKQuantityType(.height): self = .height
            case HKQuantityType(.bodyFatPercentage): self = .bodyFatPercentage
            case HKQuantityType(.leanBodyMass): self = .leanBodyMass
            default: assertionFailure(); return nil
        }
    }
}
