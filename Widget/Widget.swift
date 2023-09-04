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
        Group {
            switch widgetFamily {
                case .accessoryCircular:
                    ZStack {
                        AccessoryWidgetBackground()
                        Image(systemName: "scalemass")
                            .font(.largeTitle.weight(.medium))
                            .widgetAccentable()
                    }
                case .accessoryInline:
                    Label("Body Mass", systemImage: "scalemass")
                        .widgetAccentable()
#if os(watchOS)
                case .accessoryCorner:
                    ZStack {
                        AccessoryWidgetBackground()
                        Image(systemName: "scalemass")
                            .font(.title.weight(.medium))
                            .widgetAccentable()
                    }
#endif
                default:
                    Text(verbatim: "🐛")
            }
        }
        .modifier(Self.ContainerBackground())
    }
    private struct ContainerBackground: ViewModifier {
        func body(content: Content) -> some View {
            if #available(iOS 17.0, watchOS 10.0, *) {
                content.containerBackground(.background, for: .widget)
            } else {
                content
            }
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
        .description("Shortcut to add a data.")
#if os(iOS)
        .supportedFamilies([.accessoryCircular, .accessoryInline])
#elseif os(watchOS)
        .supportedFamilies([.accessoryCircular, .accessoryCorner, .accessoryInline])
#endif
    }
}
