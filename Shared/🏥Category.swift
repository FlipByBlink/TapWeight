import HealthKit

enum 🏥Category: Codable {
    case bodyMass, bodyMassIndex, height, bodyFatPercentage, leanBodyMass
    var identifier: HKQuantityTypeIdentifier {
        switch self {
            case .bodyMass: .bodyMass
            case .bodyMassIndex: .bodyMassIndex
            case .height: .height
            case .bodyFatPercentage: .bodyFatPercentage
            case .leanBodyMass: .leanBodyMass
        }
    }
    var localizationValue: String.LocalizationValue {
        switch self {
            case .bodyMass: "Body Mass"
            case .bodyMassIndex: "Body Mass Index"
            case .height: "Height"
            case .bodyFatPercentage: "Body Fat Percentage"
            case .leanBodyMass: "Lean Body Mass"
        }
    }
    var localizedString: String {
        String(localized: self.localizationValue)
    }
    var quantityType: HKQuantityType {
        switch self {
            case .bodyMass: .init(.bodyMass)
            case .bodyMassIndex: .init(.bodyMassIndex)
            case .height: .init(.height)
            case .bodyFatPercentage: .init(.bodyFatPercentage)
            case .leanBodyMass: .init(.leanBodyMass)
        }
    }
    var defaultUnit: HKUnit {
        switch self {
            case .bodyMass: .gramUnit(with: .kilo)
            case .bodyMassIndex: .count()
            case .height: .meter()
            case .bodyFatPercentage: .percent()
            case .leanBodyMass: .gramUnit(with: .kilo)
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
