//
//  AxisTimeFormatter.swift
//  Quotes
//
//  Created by Ilya Grechuhin on 29.09.2017.
//  Copyright © 2017 gr.ia. All rights reserved.
//

import Charts

final class AxisDateTimeFormatter: NSObject, IAxisValueFormatter {
  struct DisplayFormat: OptionSet {
    let rawValue: Int

    static let time = DisplayFormat(rawValue: 1 << 0)
    static let date = DisplayFormat(rawValue: 1 << 1)
  }

  private let formatter = DateFormatter()

  var displayFormat: DisplayFormat = [.time, .date] {
    didSet {
      let displayTime = displayFormat.contains(.time)
      let displayDate = displayFormat.contains(.date)

      if displayDate && displayTime {
        formatter.dateFormat = "dd/MM\nHH:mm"
      } else if displayDate {
        formatter.dateFormat = "dd/MM"
      } else if displayTime {
        formatter.dateFormat = "HH:mm"
      }
    }
  }

  func stringForValue(_ value: Double, axis _: AxisBase?) -> String {
    return formatter.string(from: Date(timeIntervalSince1970: value))
  }
}
