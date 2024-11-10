//
//  Sex.swift
//  ootd
//
//  Created by Gyuni on 11/10/24.
//

import Foundation

enum Sex: String, CaseIterable, Identifiable {
    case male = "남성"
    case female = "여성"
    case unisex = "유니섹스"
    
    var id: String { self.rawValue }
}
