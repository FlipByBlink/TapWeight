import SwiftUI

enum 🗒️StaticInfo {
    static let appName: LocalizedStringKey = "TapWeight"
    static let appSubTitle: LocalizedStringKey = "App for iPhone / iPad / Apple Watch"
    
    static let appStoreProductURL = URL(string: "https://apps.apple.com/app/id1624159721")!
    static var appStoreUserReviewURL: URL { URL(string: "\(Self.appStoreProductURL)?action=write-review")! }
    
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
    static let versionInfos: [(version: String, date: String)] = [("1.4", "2023-03-19"),
                                                                  ("1.3.2", "2022-12-08"),
                                                                  ("1.3.1", "2022-09-21"),
                                                                  ("1.3", "2022-09-05"),
                                                                  ("1.2", "2022-07-30"),
                                                                  ("1.1.1", "2022-06-22"),
                                                                  ("1.1", "2022-06-06"),
                                                                  ("1.0", "2022-05-23")] //降順。先頭の方が新しい
    
    enum SourceCodeCategory: String, CaseIterable, Identifiable {
        case main, Rest
        var id: Self { self }
        var fileNames: [String] {
            switch self {
                case .main: ["App.swift",
                             "📱AppModel.swift",
                             "ContentView.swift",
                             "🏥Health.swift"]
                case .Rest: ["📱extensionAppModel.swift",
                             "💥Feedback.swift",
                             "⌚️WatchSync.swift",
                             "👆RegisterButton.swift",
                             "🎚️Stepper.swift",
                             "🪧BMIView.swift",
                             "🪧LBMView.swift",
                             "📉DifferenceView.swift",
                             "💟OpenHealthAppButton.swift",
                             "📅DatePicker.swift",
                             "🗯ResultView.swift",
                             "🚨ErrorAlert.swift",
                             "🛠AppMenu.swift",
                             "🔐AuthManager.swift",
                             "🔔Notification.swift",
                             "💬RequestUserReview.swift",
                             "📣ADSheet.swift"]
            }
        }
    }
}

#elseif os(watchOS)
extension 🗒️StaticInfo {
    enum SourceCodeCategory: String, CaseIterable, Identifiable {
        case main, Rest
        var id: Self { self }
        var fileNames: [String] {
            switch self {
                case .main: ["App.swift",
                             "ContentView.swift",
                             "📱AppModel.swift",
                             "📱AppModel(Extension).swift"]
                case .Rest: ["🗒️StaticInfo.swift",
                             "ℹ️AboutApp.swift"]
            }
        }
    }
}
#endif
