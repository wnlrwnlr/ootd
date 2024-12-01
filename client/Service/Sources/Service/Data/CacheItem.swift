//
//  CacheItem.swift
//  ootd
//
//  Created by Gyuni on 11/23/24.
//

import Foundation

public class CacheItem {
    let response: String
    let expiration: Date

    init(response: String, expiration: Date) {
        self.response = response
        self.expiration = expiration
    }

    var isExpired: Bool {
        return Date() > expiration
    }
}
