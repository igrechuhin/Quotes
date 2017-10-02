//
//  ExnessQuotesTests.swift
//  QuotesTests
//
//  Created by Ilya Grechuhin on 29.09.2017.
//  Copyright © 2017 gr.ia. All rights reserved.
//

@testable import Quotes

import RxSwift
import XCTest

class ExnessQuotesTests: XCTestCase {
  private enum Config {
    static let timeout: TimeInterval = 5
  }

  private var networkQuotes: NetworkQuotes!
  private var ticksSubscription: Disposable?

  override func setUp() {
    super.setUp()
    networkQuotes = ExnessQuotes()
  }

  override func tearDown() {
    ticksSubscription?.dispose()
    ticksSubscription = nil
    networkQuotes = nil
    super.tearDown()
  }

  func testSuccessfulSubscription() {
    let exp = expectation(description: "Successful subscription")

    networkQuotes.symbols = [.BTCUSD]
    ticksSubscription = networkQuotes.ticks.subscribe(onNext: { _ in
      exp.fulfill()
    }, onError: { _ in
      XCTFail("Unexpected onError")
    }, onCompleted: {
      XCTFail("Unexpected onCompleted")
    })

    waitForExpectations(timeout: Config.timeout)
  }

  func testNoSymbolsSubscription() {
    let exp = expectation(description: "No symbols defined subscription")
    exp.isInverted = true

    ticksSubscription = networkQuotes.ticks.subscribe(onNext: { _ in
      exp.fulfill()
    }, onError: { _ in
      XCTFail("Unexpected onError")
    }, onCompleted: {
      XCTFail("Unexpected onCompleted")
    })

    waitForExpectations(timeout: Config.timeout)
  }

  func testTicksContentFor1Symbol() {
    let exp = expectation(description: "Ticks content for 1 symbol")

    networkQuotes.symbols = [.BTCUSD]
    ticksSubscription = networkQuotes.ticks.subscribe(onNext: { [weak networkQuotes] ticks in
      guard let networkQuotes = networkQuotes else {
        XCTFail("Unexpected deinit")
        return
      }
      XCTAssert(ticks.count == networkQuotes.symbols.count)
      XCTAssert(ticks.first!.symbol == networkQuotes.symbols.first!.rawValue)
      exp.fulfill()
    }, onError: { _ in
      XCTFail("Unexpected onError")
    }, onCompleted: {
      XCTFail("Unexpected onCompleted")
    })

    waitForExpectations(timeout: Config.timeout)
  }

  func testTicksContentFor2Symbols() {
    let exp = expectation(description: "Ticks content for 2 symbols")

    networkQuotes.symbols = [.BTCUSD, .EURUSD]
    ticksSubscription = networkQuotes.ticks.subscribe(onNext: { [weak networkQuotes] ticks in
      guard let networkQuotes = networkQuotes else {
        XCTFail("Unexpected deinit")
        return
      }
      XCTAssert(ticks.count == networkQuotes.symbols.count)
      networkQuotes.symbols.forEach { symbol in
        let tickForSymbol = ticks.first(where: { tick -> Bool in
          tick.symbol == symbol.rawValue
        })
        XCTAssertNotNil(tickForSymbol)
      }
      exp.fulfill()
    }, onError: { _ in
      XCTFail("Unexpected onError")
    }, onCompleted: {
      XCTFail("Unexpected onCompleted")
    })

    waitForExpectations(timeout: Config.timeout)
  }

  func testTicksContentFor1SymbolTwice() {
    let exp = expectation(description: "Ticks content for 1 symbol twice")

    networkQuotes.symbols = [.BTCUSD, .BTCUSD]
    ticksSubscription = networkQuotes.ticks.subscribe(onNext: { [weak networkQuotes] ticks in
      guard let networkQuotes = networkQuotes else {
        XCTFail("Unexpected deinit")
        return
      }
      XCTAssert(ticks.count == networkQuotes.symbols.count)
      XCTAssert(ticks.first!.symbol == networkQuotes.symbols.first!.rawValue)
      exp.fulfill()
    }, onError: { _ in
      XCTFail("Unexpected onError")
    }, onCompleted: {
      XCTFail("Unexpected onCompleted")
    })

    waitForExpectations(timeout: Config.timeout)
  }
}
