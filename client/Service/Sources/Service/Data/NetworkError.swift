//
//  NetworkError.swift
//  ootd
//
//  Created by Gyuni on 11/23/24.
//

import Foundation

public enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case decodingFailed
}
