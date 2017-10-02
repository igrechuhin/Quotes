//
//  AxisDateTimeFormatterTests.swift
//  QuotesTests
//
//  Created by Ilya Grechuhin on 29.09.2017.
//  Copyright © 2017 gr.ia. All rights reserved.
//

@testable import Quotes

import XCTest

class AxisDateTimeFormatterTests: XCTestCase {
  private let dateFormatter = AxisDateTimeFormatter()

  func testTimeFormat1() {
    dateFormatter.displayFormat = .time

    let timeIntervalSince1970: Double = 0
    let formatterValue = dateFormatter.stringForValue(timeIntervalSince1970, axis: nil)
    let expectedValue = "03:00"
    XCTAssertEqual(formatterValue, expectedValue)
  }

  func testTimeFormat2() {
    dateFormatter.displayFormat = .time

    let timeIntervalSince1970: Double = Date(timeIntervalSinceReferenceDate: 0).timeIntervalSince1970
    let formatterValue = dateFormatter.stringForValue(timeIntervalSince1970, axis: nil)
    let expectedValue = "03:00"
    XCTAssertEqual(formatterValue, expectedValue)
  }

  func testTimeFormat3() {
    dateFormatter.displayFormat = .time

    let timeIntervalSince1970: Double = Date(timeIntervalSinceReferenceDate: 3660).timeIntervalSince1970
    let formatterValue = dateFormatter.stringForValue(timeIntervalSince1970, axis: nil)
    let expectedValue = "04:01"
    XCTAssertEqual(formatterValue, expectedValue)
  }

  func testDateFormat1() {
    dateFormatter.displayFormat = .date

    let timeIntervalSince1970: Double = 0
    let formatterValue = dateFormatter.stringForValue(timeIntervalSince1970, axis: nil)
    let expectedValue = "01/01"
    XCTAssertEqual(formatterValue, expectedValue)
  }

  func testDateFormat2() {
    dateFormatter.displayFormat = .date

    let timeIntervalSince1970: Double = Date(timeIntervalSinceReferenceDate: 0).timeIntervalSince1970
    let formatterValue = dateFormatter.stringForValue(timeIntervalSince1970, axis: nil)
    let expectedValue = "01/01"
    XCTAssertEqual(formatterValue, expectedValue)
  }

  func testDateFormat3() {
    dateFormatter.displayFormat = .date

    let timeIntervalSince1970: Double = Date(timeIntervalSinceReferenceDate: 24 * 3600).timeIntervalSince1970
    let formatterValue = dateFormatter.stringForValue(timeIntervalSince1970, axis: nil)
    let expectedValue = "02/01"
    XCTAssertEqual(formatterValue, expectedValue)
  }

  func testDateFormat4() {
    dateFormatter.displayFormat = .date

    let timeIntervalSince1970: Double = Date(timeIntervalSinceReferenceDate: 30 * 24 * 3600).timeIntervalSince1970
    let formatterValue = dateFormatter.stringForValue(timeIntervalSince1970, axis: nil)
    let expectedValue = "31/01"
    XCTAssertEqual(formatterValue, expectedValue)
  }

  func testDateFormat5() {
    dateFormatter.displayFormat = .date

    let timeIntervalSince1970: Double = Date(timeIntervalSinceReferenceDate: 31 * 24 * 3600).timeIntervalSince1970
    let formatterValue = dateFormatter.stringForValue(timeIntervalSince1970, axis: nil)
    let expectedValue = "01/02"
    XCTAssertEqual(formatterValue, expectedValue)
  }

  func testDateTimeFormat1() {
    dateFormatter.displayFormat = [.time, .date]

    let timeIntervalSince1970: Double = 0
    let formatterValue = dateFormatter.stringForValue(timeIntervalSince1970, axis: nil)
    let expectedValue = "01/01\n03:00"
    XCTAssertEqual(formatterValue, expectedValue)
  }

  func testDateTimeFormat2() {
    dateFormatter.displayFormat = [.time, .date]

    let timeIntervalSince1970: Double = Date(timeIntervalSinceReferenceDate: 0).timeIntervalSince1970
    let formatterValue = dateFormatter.stringForValue(timeIntervalSince1970, axis: nil)
    let expectedValue = "01/01\n03:00"
    XCTAssertEqual(formatterValue, expectedValue)
  }

  func testDateTimeFormat3() {
    dateFormatter.displayFormat = [.time, .date]

    let timeIntervalSince1970: Double = Date(timeIntervalSinceReferenceDate: 24 * 3600 + 3660).timeIntervalSince1970
    let formatterValue = dateFormatter.stringForValue(timeIntervalSince1970, axis: nil)
    let expectedValue = "02/01\n04:01"
    XCTAssertEqual(formatterValue, expectedValue)
  }

  func testDateTimeFormat4() {
    dateFormatter.displayFormat = [.time, .date]

    let timeIntervalSince1970: Double = Date(timeIntervalSinceReferenceDate: 30 * 24 * 3600 + 3660).timeIntervalSince1970
    let formatterValue = dateFormatter.stringForValue(timeIntervalSince1970, axis: nil)
    let expectedValue = "31/01\n04:01"
    XCTAssertEqual(formatterValue, expectedValue)
  }

  func testDateTimeFormat5() {
    dateFormatter.displayFormat = [.time, .date]

    let timeIntervalSince1970: Double = Date(timeIntervalSinceReferenceDate: 31 * 24 * 3600 + 3660).timeIntervalSince1970
    let formatterValue = dateFormatter.stringForValue(timeIntervalSince1970, axis: nil)
    let expectedValue = "01/02\n04:01"
    XCTAssertEqual(formatterValue, expectedValue)
  }
}
