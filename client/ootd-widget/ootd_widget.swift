//
//  ootd_widget.swift
//  ootd-widget
//
//  Created by Gyuni on 11/10/24.
//

import WidgetKit
import SwiftUI

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationAppIntent())
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: configuration)
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        return Timeline(entries: entries, policy: .atEnd)
    }

//    func relevances() async -> WidgetRelevances<ConfigurationAppIntent> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
}

struct ootd_widgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        HStack {
            Image("sample-clothes")
                .resizable()
                .overlay {
                    Rectangle()
                        .foregroundStyle(.clear)
                        .background(LinearGradient(colors: [.clear, .clear, .secondary], startPoint: .top, endPoint: .bottom))
                }
                .overlay(alignment: .bottom) {
                    Text("남성 일상 캐주얼")
                        .bold()
                        .foregroundStyle(.white)
                        .shadow(color: .black, radius: 20)
                        .padding()
                }
        }
    }
}

struct ootd_widget: Widget {
    let kind: String = "ootd_widget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            ootd_widgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .contentMarginsDisabled()
    }
}

extension ConfigurationAppIntent {
    fileprivate static var smiley: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "😀"
        return intent
    }
}

#Preview(as: .systemSmall) {
    ootd_widget()
} timeline: {
    SimpleEntry(date: .now, configuration: .smiley)
}
