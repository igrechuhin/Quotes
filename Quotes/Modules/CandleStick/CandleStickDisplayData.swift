//
//  CandleStickDisplayData.swift
//  Quotes
//
//  Created by Ilya Grechuhin on 25.09.17.
//  Copyright © 2017 gr.ia. All rights reserved.
//

import Viperit

// MARK: - CandleStickDisplayData class
final class CandleStickDisplayData: DisplayData {
  let xAxisLabelCount = 7

  let textColor = UIColor.white
  let backgroundColor = UIColor.darkGray
  let decreasingColor = UIColor.red
  let increasingColor = UIColor.green
  let neutralColor = UIColor.lightGray

  let noDataText = "No data available. Please check your connection."
}
