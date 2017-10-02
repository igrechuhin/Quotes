//
//  CandleChartDataEntry+DatabaseCandle.swift
//  Quotes
//
//  Created by Ilya Grechuhin on 28.09.2017.
//  Copyright © 2017 gr.ia. All rights reserved.
//

import Charts

extension CandleChartDataEntry {
  convenience init(databaseCandle: DatabaseCandle) {
    self.init(x: databaseCandle.date.timeIntervalSince1970,
              shadowH: Double(databaseCandle.high.value!),
              shadowL: Double(databaseCandle.low.value!),
              open: Double(databaseCandle.open.value!),
              close: Double(databaseCandle.close.value!))
  }
}
