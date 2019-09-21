//
//  ThreadUtils.swift
//  QuizChallenge
//
//  Created by Eduardo Sanches Bocato on 21/09/19.
//  Copyright © 2019 Bocato. All rights reserved.
//

import Foundation

struct ThreadUtils {
    
    /// Submits a block for asynchronous execution on the main thread.
    static func runOnMainThread(_ block: @escaping () -> Void) {
        OperationQueue.main.addOperation(block)
    }
    
    /// Submits a block for asynchronous execution on global queue.
    /// Run at background priority; the queue is scheduled for execution after all high priority queues.
    static func runOnBackground(_ block: @escaping () -> Void) {
        OperationQueue().addOperation(block)
    }
    
    /// Enqueue a block for execution at the specified time (in Seconds). This block will be executed on main queue.
    static func runAfterDelay(_ seconds: TimeInterval, onBackground background: Bool? = false, block: @escaping () -> Void) {
        let queue = background == true ? DispatchQueue.global(qos: .background) : DispatchQueue.main
        let time = Int64(seconds * TimeInterval(NSEC_PER_SEC))
        queue.asyncAfter(deadline: DispatchTime.now() + Double(time) / Double(NSEC_PER_SEC), execute: block)
    }
    
}
