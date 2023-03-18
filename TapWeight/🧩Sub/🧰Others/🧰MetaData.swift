import Foundation

let 📜versionInfos = 📜VersionInfo.history(("1.4", "2023-03-18"),
                                           ("1.3.2", "2022-12-08"),
                                           ("1.3.1", "2022-09-21"),
                                           ("1.3", "2022-09-05"),
                                           ("1.2", "2022-07-30"),
                                           ("1.1.1", "2022-06-22"),
                                           ("1.1", "2022-06-06"),
                                           ("1.0", "2022-05-23"))

let 🔗appStoreProductURL = URL(string: "https://apps.apple.com/app/id1624159721")!

let 👤privacyPolicy = """
2022-05-22
                            
(English) This application don't collect user infomation.

(Japanese) このアプリ自身において、ユーザーの情報を一切収集しません。
"""

let 🔗webRepositoryURL = URL(string: "https://github.com/FlipByBlink/TapWeight")!
let 🔗webRepositoryURL_Mirror = URL(string: "https://gitlab.com/FlipByBlink/TapWeight_Mirror")!

enum 📁SourceCodeCategory: String, CaseIterable, Identifiable {
    case main, Shared, Sub, Others, WatchApp, WatchComplication
    var id: Self { self }
    var fileNames: [String] {
        switch self {
            case .main:
                return ["TapWeightApp.swift",
                        "ContentView.swift"]
            case .Shared:
                return ["📱AppModel.swift",
                        "🏥Health.swift",
                        "💥Feedback.swift",
                        "⌚️WatchSync.swift"]
            case .Sub:
                return ["📱extensionAppModel.swift",
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
            case .Others:
                return ["🧰MetaData.swift",
                        "ℹ️AboutApp.swift",
                        "📣AD.swift",
                        "🛒InAppPurchase.swift"]
            case .WatchApp:
                return ["WatchApp/TWApp.swift",
                        "WatchApp/ContentView.swift",
                        "WatchApp/📱extensionAppModel.swift",
                        "WatchApp/🧩SubView.swift"]
            case .WatchComplication:
                return ["WatchComplication/TW_Watch_Widget.swift"]
        }
    }
}
