import Foundation
import HealthKit

struct 🏥HealthStore {
    private let api = HKHealthStore()
    
    func authStatus(for ⓒategory: 🏥Category) -> HKAuthorizationStatus {
        self.api.authorizationStatus(for: ⓒategory.type)
    }
    
    func statusForAuthorizationRequest(toShare: [🏥Category], read: [🏥Category]) {
    }
    
    func requestAuthorization(toShare: [🏥Category], read: [🏥Category]) async throws {
    }
    
    func preferredUnits(for: [🏥Category]) async throws {
    }
    
    func execute(_ ⓠuery: HKQuery) {
    }
    
    func save(_ ⓢamples: HKSample) async throws {
    }
    
    func delete(_ ⓢamples: HKSample) async throws {
    }
    
    func ⓛoadLatestSamples(_ ⓗandler: @escaping (🏥Category, [HKSample]) -> Void ) {
        for ⓒategory: 🏥Category in [.bodyMass, .bodyMassIndex, .height, .bodyFatPercentage] {
            let ⓢortDescriptors = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
            let ⓠuery = HKSampleQuery(sampleType: ⓒategory.type,
                                      predicate: nil,
                                      limit: 1,
                                      sortDescriptors: [ⓢortDescriptors]) { _, ⓢamples, _ in
                ⓗandler(ⓒategory, ⓢamples ?? [])
            }
            self.api.execute(ⓠuery)
        }
    }
    
    func ⓞbserveChanges(_ ⓗandler: @escaping (@escaping HKObserverQueryCompletionHandler) -> Void ) {
        for ⓒategory: 🏥Category in [.bodyMass, .bodyMassIndex, .height, .bodyFatPercentage] {
            let ⓠuery = HKObserverQuery(sampleType: ⓒategory.type, predicate: nil) { _, ⓒompletionHandler, ⓔrror in
                if ⓔrror != nil { return }
                ⓗandler(ⓒompletionHandler)
            }
            self.api.execute(ⓠuery)
        }
    }
}

enum 🏥Category {
    case bodyMass, bodyMassIndex, height, bodyFatPercentage
    var identifier: HKQuantityTypeIdentifier {
        switch self {
            case .bodyMass: return .bodyMass
            case .bodyMassIndex: return .bodyMassIndex
            case .height: return .height
            case .bodyFatPercentage: return .bodyFatPercentage
        }
    }
    var description: String.LocalizationValue {
        switch self {
            case .bodyMass: return "Body Mass"
            case .bodyMassIndex: return "Body Mass Index"
            case .height: return "Height"
            case .bodyFatPercentage: return "Body Fat Percentage"
        }
    }
    var type: HKQuantityType {
        switch self {
            case .bodyMass: return HKQuantityType(.bodyMass)
            case .bodyMassIndex: return HKQuantityType(.bodyMassIndex)
            case .height: return HKQuantityType(.height)
            case .bodyFatPercentage: return HKQuantityType(.bodyFatPercentage)
        }
    }
    init?(_ ⓘdentifier: HKQuantityTypeIdentifier) {
        switch ⓘdentifier {
            case .bodyMass: self = .bodyMass
            case .bodyMassIndex: self = .bodyMassIndex
            case .height: self = .height
            case .bodyFatPercentage: self = .bodyFatPercentage
            default: return nil
        }
    }
}

enum 🏥MassUnit {
    case kg, lbs, st
    var temporaryValue: Double {
        switch self {
            case .kg: return 60.0
            case .lbs: return 130.0
            case .st: return 10.0
        }
    }
}
