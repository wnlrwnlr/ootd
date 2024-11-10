//
//  Situation.swift
//  ootd
//
//  Created by Gyuni on 11/10/24.
//

import Foundation

enum Situation: String, CaseIterable, Identifiable {
    case casual = "일상"
    case formal = "정장"
    case sports = "운동"
    case work = "업무"
    case party = "파티"
    case date = "데이트"
    case school = "학교"
    case wedding = "결혼식"

    var id: String { self.rawValue }
}
