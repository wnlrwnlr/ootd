//
//  StylePreference.swift
//  ootd
//
//  Created by Gyuni on 11/10/24.
//

import Foundation

enum StylePreference: String, CaseIterable, Identifiable {
    case casual = "캐주얼"
    case formal = "포멀"
    case sporty = "스포티"
    case street = "스트릿"
    
    var id: String { self.rawValue }
}
