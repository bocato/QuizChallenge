//
//  QuizViewData.swift
//  QuizChallenge
//
//  Created by Eduardo Sanches Bocato on 21/09/19.
//  Copyright © 2019 Bocato. All rights reserved.
//

import Foundation

struct QuizViewData {
    let title: String
    let items: [Item]
}
extension QuizViewData {
    struct Item {
        let text: String
    }
}
