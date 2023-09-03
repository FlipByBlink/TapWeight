import HealthKit

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
