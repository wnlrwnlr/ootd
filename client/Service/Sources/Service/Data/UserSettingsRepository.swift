//
//  UserSettingsRepository.swift
//  Service
//
//  Created by Gyuni on 11/23/24.
//

import Foundation

final public class UserSettingsRepository {
    // MARK: - Singleton
    nonisolated(unsafe) public static let shared = UserSettingsRepository()

    private init() {}

    private let userDefaults = UserDefaults(suiteName: "group.gyuni.ootd")

    public var sex: Sex? {
        get {
            if let value: String = get(forKey: "sex") {
                return Sex(rawValue: value)
            } else {
                return nil
            }
        } set {
            set(newValue?.rawValue ?? "", forKey: "sex")
        }
    }

    public var situation: Situation? {
        get {
            if let value: String = get(forKey: "situation") {
                return Situation(rawValue: value)
            } else {
                return nil
            }
        } set {
            set(newValue?.rawValue ?? "", forKey: "situation")
        }
    }

    public var stylePreference: StylePreference? {
        get {
            if let value: String = get(forKey: "stylePreference") {
                return StylePreference(rawValue: value)
            } else {
                return nil
            }
        } set {
            set(newValue?.rawValue ?? "", forKey: "stylePreference")
        }
    }

    public var imageURL: String? {
        get {
            return get(forKey: "imageURL")
        } set {
            set(newValue ?? "", forKey: "imageURL")
        }
    }

    public var description: String? {
        get {
            return get(forKey: "description")
        } set {
            set(newValue ?? "", forKey: "description")
        }
    }

    //  download image from url and return data
    public var imageData: Data? {
        get async {
            guard let urlString = imageURL,
                  let url = URL(string: urlString) else {
                return nil
            }

            do {
                return try await URLSession.shared.data(from: url).0
            } catch {
                return nil
            }
        }
    }

    private func set(_ value: String, forKey key: String) {
        userDefaults?.set(value, forKey: key)
    }
    private func get(forKey key: String) -> String? {
        userDefaults?.object(forKey: key) as? String
    }
}
