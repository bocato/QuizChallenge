//
//  CountdownFormatter.swift
//  QuizChallenge
//
//  Created by Eduardo Sanches Bocato on 21/09/19.
//  Copyright © 2019 Bocato. All rights reserved.
//

import Foundation

/// Defines an abstraction for the formatting process of a countdown
protocol CountDownFormatting {
    
    /// Returns a String value, in the format mm:ss,
    /// representing the seconds that were passed as a parameter
    ///
    /// - Parameter seconds: time in seconds
    /// - Returns: a String value, in the format mm:ss
    func formatToMinutes(from seconds: Int) -> String
}

final class CountDownFormatter: CountDownFormatting {
    func formatToMinutes(from timeInSeconds: Int) -> String {
        let minutes = timeInSeconds / 60
        let seconds = timeInSeconds % 60
        return String(format: "%02d", minutes) + ":" + String(format: "%02d", seconds)
    }
}
