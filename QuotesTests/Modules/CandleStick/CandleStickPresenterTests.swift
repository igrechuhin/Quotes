//
//  CandleStickPresenterTests.swift
//  QuotesTests
//
//  Created by Ilya Grechuhin on 29.09.2017.
//  Copyright © 2017 gr.ia. All rights reserved.
//

@testable import Quotes
@testable import RxRealm

import Charts
import RealmSwift
import RxSwift
import Viperit
import XCTest

class MockCandleStickView: UserInterface, CandleStickViewApi {
  var setupExpectation: XCTestExpectation?
  var updateExpectation: XCTestExpectation?

  func setup() {
    setupExpectation?.fulfill()
  }

  func update(data _: [CandleChartDataEntry], label _: String) {
    updateExpectation?.fulfill()
  }
}

class MockCandleStickInteractor: Interactor, CandleStickInteractorApi {
  var dataChangeSetExpectation: XCTestExpectation?

  var dataChangeSet: Observable<(AnyRealmCollection<DatabaseCandle>, RealmChangeset?)>? {
    dataChangeSetExpectation?.fulfill()
    return Observable.create({ observer in
      let realm = try! Database.instance(storage: .inMemory)
      let candles = DatabaseCandle1M.candles(realm: realm, symbol: QuotesSymbol.BTCUSD.rawValue)
      let results = AnyRealmCollection<DatabaseCandle>(candles)

      observer.onNext((results, nil))
      observer.onNext((results, RealmChangeset(deleted: [], inserted: [], updated: [])))

      return Disposables.create {}
    })
  }

  func setup(symbol _: QuotesSymbol, storage _: Database.Storage) {}
}

class CandleStickPresenterTests: XCTestCase {
  var mockView: MockCandleStickView!
  var mockInteractor: MockCandleStickInteractor!

  override func setUp() {
    super.setUp()
    var module = AppModules.CandleStick.build()
    mockView = MockCandleStickView()
    module.injectMock(view: mockView)
    mockInteractor = MockCandleStickInteractor()
    module.injectMock(interactor: mockInteractor)
  }

  func testViewHasLoaded() {
    mockView.setupExpectation = expectation(description: "Test view setup method is called")
    mockInteractor.dataChangeSetExpectation = expectation(description: "Test dataChangeSet property requested")
    mockView.updateExpectation = expectation(description: "Test view update method is called")
    mockView.updateExpectation?.expectedFulfillmentCount = 2

    mockView.viewDidLoad()

    waitForExpectations(timeout: 10)
  }
}
