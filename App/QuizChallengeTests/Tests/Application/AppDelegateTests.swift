//
//  AppDelegate+FactoriesTests.swift
//  QuizChallengeTests
//
//  Created by Eduardo Sanches Bocato on 22/09/19.
//  Copyright © 2019 Bocato. All rights reserved.
//

import XCTest
@testable import QuizChallenge

final class AppDelegateTests: XCTestCase {
    
    func test_whenApplicationDidFinishLaunchingWithOptionsIsCalled_theRootwControllerShouldBeKeywordsViewController() {
        // Given
        let appDelegate = AppDelegate()
        
        // When
        _ = appDelegate.application(UIApplication.shared, didFinishLaunchingWithOptions: nil)
        
        // Then
        let rootViewController = appDelegate.window?.rootViewController
        XCTAssertTrue(rootViewController is KeywordsViewController, "The rootViewController should be a `KeywordsViewController`")
    }
    
    func test_whenMakeKeywordsViewController_itShouldHaveTheCorrectPropertiesSet() {
        // Given
        let appDelegate: KeywordsFactoryProtocol = AppDelegate()
        
        // When
        let sut = appDelegate.makeKeywordsViewController()
        
        // -> KeywordsViewController Dependencies <-
        let keywordsViewControllerMirror = Mirror(reflecting: sut)
        guard let viewModel = keywordsViewControllerMirror.firstChild(of: KeywordsViewModel.self) else {
            XCTFail("Could not find KeywordsViewModel.")
            return
        }
        
        // -> KeywordsViewModel Dependencies <-
        let viewModelMirror = Mirror(reflecting: viewModel)
        let timerPeriod = viewModelMirror.firstChild(of: Int.self, in: "timerPeriod")
        let countDownTimer = viewModelMirror.firstChild(of: CountDownTimer.self)
        let fetchQuizUseCase = viewModelMirror.firstChild(of: FetchQuizUseCase.self)
        let countDownFormatter = viewModelMirror.firstChild(of: CountDownFormatter.self)
        let countRightAnswersUseCase = viewModelMirror.firstChild(of: CountRightAnswersUseCase.self)
        
        // Then
        XCTAssertEqual(timerPeriod, 300, "`timerPeriod` should be 300 by default")
        XCTAssertNotNil(countDownTimer, "A `CountDownTimer` should have been provided.")
        XCTAssertNotNil(fetchQuizUseCase, "A `FetchQuizUseCase` should have been provided.")
        XCTAssertNotNil(countDownFormatter, "A `CountDownFormatter` should have been provided.")
        XCTAssertNotNil(countRightAnswersUseCase, "A `CountRightAnswersUseCase` should have been provided.")
        XCTAssertNotNil(viewModel.viewStateRenderer, "The `viewStateRenderer` should not be nil.")
        XCTAssertNotNil(viewModel.viewModelBinder, "The `viewModelBinder` should not be nil.")
    }

}
