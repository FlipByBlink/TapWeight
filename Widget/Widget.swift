import WidgetKit
import SwiftUI

private struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry { .init() }
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        completion(.init())
    }
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        completion(Timeline(entries: [.init()], policy: .never))
    }
}

private struct SimpleEntry: TimelineEntry {
    let date: Date = .now
}

private struct EntryView : View {
    @Environment(\.widgetFamily) var widgetFamily
    var body: some View {
        switch widgetFamily {
            case .accessoryCircular, .accessoryCorner:
                ZStack {
                    AccessoryWidgetBackground()
                    Image(systemName: "scalemass")
                        .font(.largeTitle.weight(.medium))
                        .widgetAccentable()
                }
            case .accessoryInline:
                Label("Body Mass", systemImage: "scalemass")
                    .widgetAccentable()
            default:
                Text(verbatim: "🐛")
        }
    }
}

@main
struct TapWeightWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "TW_Watch_Widget", provider: Provider()) { _ in
            EntryView()
        }
        .configurationDisplayName("Shortcut")
        .supportedFamilies([.accessoryCircular,
                            .accessoryCorner,
                            .accessoryInline])
    }
}
