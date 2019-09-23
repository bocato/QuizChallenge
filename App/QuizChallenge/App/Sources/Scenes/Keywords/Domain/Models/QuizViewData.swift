//
//  QuizViewData.swift
//  QuizChallenge
//
//  Created by Eduardo Sanches Bocato on 21/09/19.
//  Copyright © 2019 Bocato. All rights reserved.
//

import Foundation

/// Defines the data model that the views that
/// need a quiz information will receive
struct QuizViewData {
    let title: String
    let items: [Item]
}
extension QuizViewData {
    struct Item {
        let text: String
    }
}
