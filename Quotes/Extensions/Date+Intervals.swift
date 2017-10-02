//
//  Date+Intervals.swift
//  Quotes
//
//  Created by Ilya Grechuhin on 27.09.17.
//  Copyright © 2017 gr.ia. All rights reserved.
//

import Foundation

extension Date {
  typealias StepInterval = Int

  private enum Const {
    static let secondsPerMinute = 60
    static let secondsPerDay = 24 * 60 * 60
  }

  init(minutesSince1970: StepInterval) {
    self.init(timeIntervalSince1970: TimeInterval(minutesSince1970 * Const.secondsPerMinute))
  }

  var minutesSince1970: StepInterval {
    return StepInterval(timeIntervalSince1970 / TimeInterval(Const.secondsPerMinute))
  }

  var minutesIntervalDate: Date {
    return Date(minutesSince1970: minutesSince1970)
  }

  static func +(lhs: Date, rhs: Date.StepInterval) -> Date {
    return Date(minutesSince1970: lhs.minutesSince1970 + rhs)
  }

  static func isSameDay(lhs: Date, rhs: Date) -> Bool {
    let lhsDay = Int(lhs.timeIntervalSince1970 / TimeInterval(Const.secondsPerDay))
    let rhsDay = Int(rhs.timeIntervalSince1970 / TimeInterval(Const.secondsPerDay))
    return lhsDay == rhsDay
  }
}
