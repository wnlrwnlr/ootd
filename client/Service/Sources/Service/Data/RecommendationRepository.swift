//
//  RecommendationRepository.swift
//  ootd
//
//  Created by Gyuni on 11/23/24.
//

import Foundation

final public class RecommendationRepository {
    private let baseURL = "http://43.203.231.210:5000/recommand"
    private let cache = NSCache<NSString, CacheItem>()
    private let cacheExpiration: TimeInterval = 60 * 60 * 24 // 1 day in seconds

    // MARK: - Singleton
    nonisolated(unsafe) public static let shared = RecommendationRepository()

    private init() {}

    // MARK: - Async Request Method
    public func fetchRecommendation(description: String) async throws -> String {
        let cacheKey = NSString(string: description)

        // Check Cache
        if let cachedItem = cache.object(forKey: cacheKey), !cachedItem.isExpired {
            return cachedItem.response
        }

        // Build URL
        guard var urlComponents = URLComponents(string: baseURL) else {
            throw NetworkError.invalidURL
        }

        urlComponents.queryItems = [
            URLQueryItem(name: "description", value: description)
        ]

        guard let url = urlComponents.url else {
            throw NetworkError.invalidURL
        }

        // Create Request
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        // Perform Request
        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }

        // Decode Response
        guard let responseString = String(data: data, encoding: .utf8) else {
            throw NetworkError.decodingFailed
        }

        // Cache the Result
        let cacheItem = CacheItem(response: responseString, expiration: Date().addingTimeInterval(cacheExpiration))
        cache.setObject(cacheItem, forKey: cacheKey)

        return responseString
    }
}
