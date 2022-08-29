
import HealthKit

enum 📏BodyMassUnit: String, CaseIterable {
    case kg
    case lbs
    case st
    
    var asHKUnit: HKUnit {
        switch self {
            case .kg: return .gramUnit(with: .kilo)
            case .lbs: return .pound()
            case .st: return .stone()
        }
    }
}
