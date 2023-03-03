import Foundation
import HealthKit

struct 🏥HealthStore {
    private let ⓐpi = HKHealthStore()
    
    func authorizationStatus(for ⓒategory: 🏥Category) -> HKAuthorizationStatus {
        self.ⓐpi.authorizationStatus(for: ⓒategory.quantityType)
    }
    
    func statusForAuthorizationRequest(toShare ⓣypesToShare: Set<🏥Category>,
                                       read ⓣypesToRead: Set<🏥Category>) async throws -> HKAuthorizationRequestStatus {
        try await self.ⓐpi.statusForAuthorizationRequest(toShare: Set(ⓣypesToShare.map { $0.quantityType }),
                                                         read: Set(ⓣypesToRead.map { $0.quantityType }))
    }
    
    func requestAuthorization(toShare ⓣypesToShare: Set<🏥Category>,
                              read ⓣypesToRead: Set<🏥Category>) async throws {
        try await self.ⓐpi.requestAuthorization(toShare: Set(ⓣypesToShare.map { $0.quantityType }),
                                                read: Set(ⓣypesToRead.map { $0.quantityType }))
    }
    
    func preferredUnit(for ⓒategory: 🏥Category) async throws -> HKUnit? {
        try await self.ⓐpi.preferredUnits(for: [ⓒategory.quantityType]).first?.value
    }
    
    func save(_ ⓢamples: [HKSample]) async throws {
        try await self.ⓐpi.save(ⓢamples)
    }
    
    func delete(_ ⓢamples: [HKSample]) async throws {
        try await self.ⓐpi.delete(ⓢamples)
    }
    
    func ⓛoadLatestSamples(_ ⓗandler: @escaping (🏥Category, [HKSample]) -> Void ) {
        for ⓒategory: 🏥Category in [.bodyMass, .bodyMassIndex, .height, .bodyFatPercentage] {
            let ⓢortDescriptors = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
            let ⓠuery = HKSampleQuery(sampleType: ⓒategory.quantityType,
                                      predicate: nil,
                                      limit: 1,
                                      sortDescriptors: [ⓢortDescriptors]) { _, ⓢamples, _ in
                ⓗandler(ⓒategory, ⓢamples ?? [])
            }
            self.ⓐpi.execute(ⓠuery)
        }
    }
    
    func ⓞbserveChanges(_ ⓗandler: @escaping (@escaping HKObserverQueryCompletionHandler) -> Void ) {
        for ⓒategory: 🏥Category in [.bodyMass, .bodyMassIndex, .height, .bodyFatPercentage] {
            let ⓠuery = HKObserverQuery(sampleType: ⓒategory.quantityType, predicate: nil) { _, ⓒompletionHandler, ⓔrror in
                if ⓔrror != nil { return }
                ⓗandler(ⓒompletionHandler)
            }
            self.ⓐpi.execute(ⓠuery)
        }
    }
}

enum 🏥Category {
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
    var description: String.LocalizationValue {
        switch self {
            case .bodyMass: return "Body Mass"
            case .bodyMassIndex: return "Body Mass Index"
            case .height: return "Height"
            case .bodyFatPercentage: return "Body Fat Percentage"
            case .leanBodyMass: return "Lean Body Mass"
        }
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
    init?(_ ⓘdentifier: HKQuantityTypeIdentifier) {
        switch ⓘdentifier {
            case .bodyMass: self = .bodyMass
            case .bodyMassIndex: self = .bodyMassIndex
            case .height: self = .height
            case .bodyFatPercentage: self = .bodyFatPercentage
            case .leanBodyMass: self = .leanBodyMass
            default:
                assertionFailure()
                return nil
        }
    }
    init?(_ ⓣype: HKQuantityType) {
        switch ⓣype {
            case HKQuantityType(.bodyMass): self = .bodyMass
            case HKQuantityType(.bodyMassIndex): self = .bodyMassIndex
            case HKQuantityType(.height): self = .height
            case HKQuantityType(.bodyFatPercentage): self = .bodyFatPercentage
            case HKQuantityType(.leanBodyMass): self = .leanBodyMass
            default:
                assertionFailure()
                return nil
        }
    }
}
