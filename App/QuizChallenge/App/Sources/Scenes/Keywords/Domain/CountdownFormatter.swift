//
//  CountdownFormatter.swift
//  QuizChallenge
//
//  Created by Eduardo Sanches Bocato on 21/09/19.
//  Copyright © 2019 Bocato. All rights reserved.
//

import Foundation

protocol CountDownFormatting {
    func formatToMinutes(from seconds: Int) -> String
}

final class CountDownFormatter: CountDownFormatting {
    func formatToMinutes(from timeInSeconds: Int) -> String {
        let minutes = timeInSeconds / 60
        let seconds = timeInSeconds % 60
        return String(format: "%02d", minutes) + ":" + String(format: "%02d", seconds)
    }
}
