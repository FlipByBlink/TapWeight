import SwiftUI

enum 🗒️StaticInfo {
    static let appName: LocalizedStringKey = "TapWeight"
    static let appSubTitle: LocalizedStringKey = "App for iPhone / iPad / Apple Watch"
    
    static let appStoreProductURL = URL(string: "https://apps.apple.com/app/id1624159721")!
    static var appStoreUserReviewURL: URL { .init(string: "\(Self.appStoreProductURL)?action=write-review")! }
    
    static var contactAddress: String { "sear_pandora_0x@icloud.com" }
    
    static let privacyPolicyDescription = """
        2022-05-22
        
        (English) This application don't collect user infomation.
        
        (Japanese) このアプリ自身において、ユーザーの情報を一切収集しません。
        """
    
    static let webRepositoryURL = URL(string: "https://github.com/FlipByBlink/TapWeight")!
    static let webMirrorRepositoryURL = URL(string: "https://gitlab.com/FlipByBlink/TapWeight_Mirror")!
}

#if os(iOS)
extension 🗒️StaticInfo {
    static let versionInfos: [(version: String, date: String)] = [("1.5", "2023-09-01"),
                                                                  ("1.4", "2023-03-19"),
                                                                  ("1.3.2", "2022-12-08"),
                                                                  ("1.3.1", "2022-09-21"),
                                                                  ("1.3", "2022-09-05"),
                                                                  ("1.2", "2022-07-30"),
                                                                  ("1.1.1", "2022-06-22"),
                                                                  ("1.1", "2022-06-06"),
                                                                  ("1.0", "2022-05-23")] //降順。先頭の方が新しい
    
    enum SourceCodeCategory: String, CaseIterable, Identifiable {
        case main, Rest, Widget
        var id: Self { self }
        var fileNames: [String] {
            switch self {
                case .main: ["App.swift",
                             "ContentView.swift",
                             "📱AppModel.swift",
                             "📱AppModel(extension).swift",
                             "🏥HealthStore.swift",
                             "🏥Category.swift"]
                case .Rest: ["🎚️StepperAction.swift",
                             "🎚️BodyFatStepper.swift",
                             "🎚️BodyMassStepper.swift",
                             "👆RegisterButton.swift",
                             "🗯ResultView.swift",
                             "🪧BMIView.swift",
                             "🪧LBMView.swift",
                             "📉Difference.swift",
                             "📉DifferenceView.swift",
                             "📅DatePicker.swift",
                             "🛠AppMenu.swift",
                             "🛠BMIMenu.swift",
                             "🛠LBMMenu.swift",
                             "🛠ReminderMenu.swift",
                             "⌚️WatchSync.swift",
                             "💥Feedback.swift",
                             "🔐AuthManager.swift",
                             "🚨Error.swift",
                             "🚨ErrorAlert.swift",
                             "💟OpenHealthAppButton.swift",
                             "💬RequestUserReview.swift",
                             "📣ADComponents.swift",
                             "📣ADModel.swift",
                             "📣ADSheet.swift",
                             "🔔Notification.swift",
                             "🛒InAppPurchaseModel.swift",
                             "🛒InAppPurchaseView.swift",
                             "ℹ️AboutApp.swift",
                             "🗒️StaticInfo.swift"]
                case .Widget: ["Widget.swift"]
            }
        }
    }
}

#elseif os(watchOS)
extension 🗒️StaticInfo {
    enum SourceCodeCategory: String, CaseIterable, Identifiable {
        case main, Rest, Widget
        var id: Self { self }
        var fileNames: [String] {
            switch self {
                case .main: ["App.swift",
                             "ContentView.swift",
                             "📱AppModel.swift",
                             "📱AppModel(extension).swift",
                             "🏥HealthStore.swift",
                             "🏥Category.swift"]
                case .Rest: ["🎚️StepperAction.swift",
                             "🎚️BodyFatStepper.swift",
                             "🎚️BodyMassStepper.swift",
                             "👆RegisterButton.swift",
                             "🗯ResultView.swift",
                             "🪧BMIView.swift",
                             "🪧LBMView.swift",
                             "⌚️WatchSync.swift",
                             "💥Feedback.swift",
                             "🔐AuthManager.swift",
                             "🚨Error.swift",
                             "🚨ErrorAlert.swift",
                             "🚨ErrorMessage.swift",
                             "ℹ️AboutAppButton.swift",
                             "ℹ️AboutApp.swift",
                             "📉Difference.swift",
                             "🏥CheckEarliestPermittedSampleDateView.swift",
                             "🗒️StaticInfo.swift"]
                case .Widget: ["Widget.swift"]
            }
        }
    }
}
#endif
