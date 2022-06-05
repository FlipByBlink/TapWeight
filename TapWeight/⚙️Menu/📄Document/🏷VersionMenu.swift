
import SwiftUI

struct 🏷VersionMenu: View {
    var body: some View {
        Section {
            NavigationLink {
                ScrollView {
                    📋TextView(🕒VersionHistory, "Version history")
                }
            } label: {
                Label("1.1" , systemImage: "signpost.left")
            }
        } header: {
            Text("Version")
        } footer: {
            let 📅 = Date.now.formatted(date: .numeric, time: .omitted)
            Text("builded on \(📅)")
        }
    }
}

let 🕒VersionHistory = """
                        🕒 Version 1.1 : (2022/06/05?)
                        Add "Cancel" feature.
                        Add amount opiton of stepper. 100g → 50g.
                        Improve several small UI design.
                        Change local history format to CSV style.
                        Add 3 keywords(Body Mass/Body Mass Index/Body Fat Percentage) localization for Simplified_Chinese, Traditional_Chinese, Spanish, Portuguese, Russian, Indonesian, French, Arabic, German, Korean.
                        ==== Native(japanese) ====
                        取り消し機能の追加
                        体重の入力単位を100gから50gへ変更するオプションの追加
                        様々な細かなUIの改善
                        ローカル履歴の形式をCSVスタイルに変更
                        主要3単語(体重/BMI/体脂肪率)のローカライズを追加。中国語簡体字/繁体字/スペイン語/ポルトガル語/ロシア語/インドネシア語/フランス語/アラビア語/ドイツ語/韓国語。
                        
                        
                        🕒 Version 1.0 : 2022/05/23
                        Initial release
                        """
