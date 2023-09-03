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
