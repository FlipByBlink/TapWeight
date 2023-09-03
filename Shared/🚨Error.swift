enum 🚨Error: Error {
    case failedAuth(🏥Category)
    case noInputValue(🏥Category)
    case saveFailure(String)
    case deleteFailure(String)
    var message: String {
        switch self {
            case .failedAuth(let ⓒategory):
                String(localized: "Authorization error: ") + ⓒategory.localizedString
            case .noInputValue(let ⓒategory):
                String(localized: "No input value: ") + ⓒategory.localizedString
            case .saveFailure(let ⓓescription):
                String(localized: "Save error: \(ⓓescription)")
            case .deleteFailure(let ⓓescription):
                String(localized: "Delete error: \(ⓓescription)")
        }
    }
}
