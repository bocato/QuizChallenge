//
//  CountDownTimer.swift
//  QuizChallenge
//
//  Created by Eduardo Sanches Bocato on 21/09/19.
//  Copyright © 2019 Bocato. All rights reserved.
//

import Foundation

protocol CountDownTimerProvider {
    
    /// Starts a timer and sends a callback when it is finished on changed
    ///
    /// - Parameters:
    ///   - timePeriod: the time period the contdown will run
    ///   - timeInterval: the interval the timer will tick
    ///   - onTick: sends a callback everytime the timer passes the defined interval
    ///   - onFinish: sends  a callback when the timer finishes
    func dispatch(
        forTimePeriodInSeconds period: Int,
        timeInterval: TimeInterval,
        onTick: ((_ remainingSeconds: Int) -> Void)?,
        onFinish: (() -> Void)?
    )
    
    /// Restarts the timer using the last TimerPeriod set
    func restart()
    
    // Stops the timer
    func stop()
    
    /// Tells us if the timer is running:
    /// true, if the timer is running, false otherwise
    var isRunning: Bool { get }
}
final class CountDownTimer: CountDownTimerProvider {
    
    // MARK: - Private Properties
    
    private var timer: Timer?
    private var lastTimerPeriod: Int = 0
    private var lastTimeInterval: TimeInterval = 1.0
    private var lastOnTickClosure: ((_ remainingSeconds: Int) -> Void)?
    private var lastOnFinishClosure: (() -> Void)?
    private var timerWasStopped: Bool = false
    private var timeLeft: Int = 0
    
    // MARK: - Public Properties
    
    /// Tells us if the timer is running:
    /// true, if the timer is running, false otherwise
    var isRunning: Bool {
        return timer != nil
    }
    
    // MARK: - Initialization
    
    public init() {}
    
    // MARK: - Public Methods
    
    /// Starts a timer and sends a callback when it is finished on changed
    ///
    /// - Parameters:
    ///   - timePeriod: the time period the contdown will run
    ///   - timeInterval: the interval the timer will tick
    ///   - onTick: sends a callback everytime the timer passes the defined interval
    ///   - onFinish: sends  a callback when the timer finishes
    func dispatch(
        forTimePeriodInSeconds period: Int,
        timeInterval: TimeInterval = 1.0,
        onTick: ((_ remainingSeconds: Int) -> Void)? = nil,
        onFinish: (() -> Void)? = nil
    ) {
        
        lastTimerPeriod = period
        lastTimeInterval = timeInterval
        lastOnTickClosure = onTick
        lastOnFinishClosure = onFinish
        
        var timeLeft = period
        self.timeLeft = timeLeft
        timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true, block: { [weak self] _ in
            timeLeft -= 1
            if timeLeft <= 0 {
                self?.stop()
                onFinish?()
            }
            onTick?(timeLeft)
        })
        
    }
    
    /// Restarts the timer using the last TimerPeriod set
    func restart() {
        timer?.invalidate()
        dispatch(
            forTimePeriodInSeconds: lastTimerPeriod,
            timeInterval: lastTimeInterval,
            onTick: lastOnTickClosure,
            onFinish: lastOnFinishClosure
        )
    }
    
    // Stops the timer
    func stop() {
        timer?.invalidate()
        timer = nil
    }
    
}
