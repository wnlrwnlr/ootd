//
//  ootd_widget.swift
//  ootd-widget
//
//  Created by Gyuni on 11/10/24.
//

import WidgetKit
import SwiftUI
import Service

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> Entry {
        Entry(date: Date(), imageData: Data())
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> Entry {
        let imageData = await UserSettingsRepository.shared.imageData ?? Data()
        return Entry(date: Date(), imageData: imageData)
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<Entry> {
        let imageData = await UserSettingsRepository.shared.imageData ?? Data()

        var entries: [Entry] = []

        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = Entry(date: entryDate, imageData: imageData)
            entries.append(entry)
        }

        return Timeline(entries: entries, policy: .atEnd)
    }
}

struct Entry: TimelineEntry {
    var date: Date

    let imageData: Data
}

struct ootd_widgetEntryView : View {
    var entry: Provider.Entry
    
    private let userSettingsRepository = UserSettingsRepository.shared
    
    var image: Image {
        if let uiImage = UIImage(data: entry.imageData)?.resized(toWidth: 400) {
            Image(uiImage: uiImage)
        } else {
            Image("sample-clothes")
        }
    }

    var body: some View {
        HStack {
            image
                .resizable()
                .overlay {
                    Rectangle()
                        .foregroundStyle(.clear)
                        .background(LinearGradient(colors: [.clear, .clear, .secondary], startPoint: .top, endPoint: .bottom))
                }
                .overlay(alignment: .bottom) {
                    if let sex = userSettingsRepository.sex,
                       let situation = userSettingsRepository.situation,
                       let stylePreference = userSettingsRepository.stylePreference {
                        Text("\(sex.rawValue) \(situation.rawValue) \(stylePreference.rawValue)")
                            .bold()
                            .foregroundStyle(.white)
                            .shadow(color: .black, radius: 20)
                            .shadow(color: .black, radius: 20)
                            .padding()
                    }
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

#Preview(as: .systemSmall) {
    ootd_widget()
} timeline: {
    Entry(date: .now, imageData: Data())
}

extension UIImage {
  func resized(toWidth width: CGFloat, isOpaque: Bool = true) -> UIImage? {
    let canvas = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
    let format = imageRendererFormat
    format.opaque = isOpaque
    return UIGraphicsImageRenderer(size: canvas, format: format).image {
      _ in draw(in: CGRect(origin: .zero, size: canvas))
    }
  }
}
