//
//  CandleStickInteractorTests.swift
//  QuotesTests
//
//  Created by Ilya Grechuhin on 29.09.2017.
//  Copyright © 2017 gr.ia. All rights reserved.
//

@testable import Quotes

import XCTest
import Viperit

class MockCandleStickPresenter: Presenter, CandleStickPresenterApi {
  var updateDataSubscriptionExpectation: XCTestExpectation?

  func updateDataSubscription() {
    updateDataSubscriptionExpectation?.fulfill()
  }
}

class CandleStickInteractorTests: XCTestCase {
  var mockPresenter: MockCandleStickPresenter!
  var interactor: CandleStickInteractor!
  var module = AppModules.CandleStick.build()

  override func setUp() {
    super.setUp()
    mockPresenter = MockCandleStickPresenter()
    module.injectMock(presenter: mockPresenter)
    interactor = module.interactor as! CandleStickInteractor
  }

  func testUpdateDataSubscription() {
    mockPresenter.updateDataSubscriptionExpectation = expectation(description: "Test updateDataSubscription is called")

    interactor.setup(symbol: .BTCUSD, storage: .inMemory)

    waitForExpectations(timeout: 10)
  }
}
