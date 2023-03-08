import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: .now)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        completion(SimpleEntry(date: .now))
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        completion(Timeline(entries: [SimpleEntry(date: .now)], policy: .never))
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
}

struct TW_Watch_WidgetEntryView : View {
    @Environment(\.widgetFamily) var widgetFamily
    var body: some View {
        switch widgetFamily {
            case .accessoryCircular, .accessoryCorner:
                ZStack {
                    AccessoryWidgetBackground()
                    Image(systemName: "scalemass")
                        .font(.largeTitle.weight(.medium))
                }
                .widgetAccentable()
            case .accessoryInline:
                Label("Body Mass", systemImage: "scalemass")
                    .widgetAccentable()
            default:
                Text("🐛")
        }
    }
}

@main
struct TW_Watch_Widget: Widget {
    let kind: String = "TW_Watch_Widget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { _ in
            TW_Watch_WidgetEntryView()
        }
        .configurationDisplayName("Shortcut")
        .supportedFamilies([.accessoryCircular,
                            .accessoryCorner,
                            .accessoryInline])
    }
}

struct TW_Watch_Widget_Previews: PreviewProvider {
    static var previews: some View {
        TW_Watch_WidgetEntryView()
            .previewContext(WidgetPreviewContext(family: .accessoryCorner))
    }
}
