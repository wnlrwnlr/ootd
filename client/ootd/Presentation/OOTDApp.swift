//
//  OOTDApp.swift
//  ootd
//
//  Created by Gyuni on 11/6/24.
//

import SwiftUI
import Sentry

@main
struct OOTDApp: App {
    init() {
        SentrySDK.start { options in
            print("https://\(Bundle.main.object(forInfoDictionaryKey: "SENTRY_DSN") as? String ?? "")")
            options.dsn = "https://\(Bundle.main.object(forInfoDictionaryKey: "SENTRY_DSN") as? String ?? "")"

            options.tracesSampleRate = 1.0
            options.profilesSampleRate = 1.0
        }
    }

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ContentView()
            }
            .tint(.brown)
        }
    }
}
