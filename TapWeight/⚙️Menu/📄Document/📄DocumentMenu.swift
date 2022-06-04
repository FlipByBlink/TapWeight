
import SwiftUI

struct 📄DocumentMenu: View {
    @EnvironmentObject var 📱:📱Model
    
    var body: some View {
        NavigationLink {
            List {
                Section {
                    Label("1.1" , systemImage: "signpost.left")
                } header: {
                    Text("Version")
                } footer: {
                    let 📅 = Date.now.formatted(date: .numeric, time: .omitted)
                    Text("builded on \(📅)")
                }
                
                
                Section {
                    NavigationLink {
                        ScrollView {
                            📋TextView(📄About, "About app")
                        }
                    } label: {
                        Text(📄About)
                            .font(.subheadline)
                            .lineLimit(7)
                            .padding(8)
                    }
                } header: {
                    Text("About")
                }
                
                
                let 🔗 = "https://apps.apple.com/developer/id1347562710"
                Section {
                    Link(destination: URL(string: 🔗)!) {
                        HStack {
                            Label("Open AppStore page", systemImage: "link")
                            
                            Spacer()
                            
                            Image(systemName: "arrow.up.forward.app")
                        }
                    }
                } footer: {
                    Text(🔗)
                }
                
                Section {
                    Text("""
                        2022-05-22
                        (English)This application don't collect user infomation.
                        (Japanese)このアプリ自身において、ユーザーの情報を一切収集しません。
                        """)
                    .font(.subheadline)
                    .padding(8)
                    .textSelection(.enabled)
                } header: {
                    Text("Privacy Policy")
                }
                
                
                Section {
                    NavigationLink {
                        Text("🌏TextAboutAD")
                            .padding()
                            .navigationTitle("🌏About self-AD")
                            .textSelection(.enabled)
                    } label: {
                        Label("🌏About self-AD", systemImage: "exclamationmark.bubble")
                    }
                }
                
                
                NavigationLink {
                    📓SourceCodeMenu()
                } label: {
                    Label("Source code", systemImage: "doc.plaintext")
                }
            }
            .navigationTitle("App Document")
        } label: {
            Label("App Document", systemImage: "doc")
        }
    }
}


let 📄About = """
                    This application is designed to register weight data to the Apple "Health" application pre-installed on iPhone in the fastest possible way (as manual).
                    
                    People frequently measure their weight and body fat percentage daily using a scale. Many iPhone users register their weight and body fat percentage data on "Health" app. The best solution is to use a smart scale that works with "Health" app and automatically stores measurements, but they are expensive and inaccessible. Manual data registration is possible in "Health" app, but "Health" app is not designed for daily manual data registration. Therefore, manually entering data that occur continuously daily, such as weight measurements, is a very time-consuming and stressful experience. This app was developed to solve such problems.
                    
                    This app cannot read, view, or manage past data in "Health" app. This app is intended only to register data to the "Health" app. Please check the registered data on the "Health" app.
                    
                    【Target/Use-case】
                    - No "smart" scale.
                    - Frequently measure my weight (and body fat percentage) using a scale almost every day.
                    - Intend to register the data into "Health" app every time, after measuring by a scale.
                    
                    【OPTION】
                    - With body fat percentage.
                    - With body mass index automatically.
                    - Unit: kg, lbs, st
                    
                    【OTHERS】
                    - Launch "Health" app by one tap.
                    - Local history for the purpose of "operation check" / "temporary backup".
                    - Check source code in app.
                    - All feature is free.
                    - Rarely appear AD banner of app by TapWeight developer.
                    
                    
                    ==== Native(japanese) ====
                    iPhoneにプリインストールされているApple「ヘルスケア」アプリに体重データを(手動としては)最速で登録するためのアプリです。
                    
                    人々は体重計を用いて体重や体脂肪率は日々頻繁に計測します。多くのiPhoneユーザーは「ヘルスケア」アプリ上に体重や体脂肪率のデータを登録しています。「ヘルスケア」アプリと連携して自動的に計測データを保存してくれるスマート体重計を用いることが最高の解決策ではありますが、それらは高価であったり入手性が低かったりします。「ヘルスケア」アプリ上で手動でもデータ登録は可能ですが、残念ながら「ヘルスケア」アプリは計測データを日常的に手動で登録することを想定されていません。そのため体重測定のような日々継続的に発生するデータを手動で入力することは大いに手間が掛かりストレスフルな体験になります。そうした課題を解決するためにこのアプリは開発しました。
                    
                    このアプリでは「ヘルスケア」アプリ上の過去のデータの読み込みや閲覧、管理等は出来ません。このアプリは「ヘルスケア」アプリへのデータ登録のみを目的としています。登録したデータは「ヘルスケア」アプリ上で確認してください。
                    
                    【想定ユーザー/ユースケース】
                    - スマート体重計を持っていない。
                    - 日常的に体重や体脂肪率を体重計で計測している。
                    - 体重計で測定した直後、毎回手動で測定結果を「ヘルスケア」アプリに登録する事を検討している。
                    
                    【オプション】
                    - 体脂肪率も同時に登録可能。
                    - BMIを自動的に計算して同時に登録可能。
                    - 単位: kg, lbs, st
                    
                    【その他】
                    - このアプリ内からApple「ヘルスケア」アプリをワンタップで立ち上げ可能。
                    - 動作確認や簡易バックアップを想定した端末内での履歴機能。
                    - アプリ内でアプリ自身のソースコードを確認。
                    - すべての機能を無料で利用できます。
                    - 自作アプリに関するバナー広告をアプリ内で比較的控えめに表示します。
                    """
