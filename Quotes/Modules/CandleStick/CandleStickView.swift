//
//  CandleStickView.swift
//  Quotes
//
//  Created by Ilya Grechuhin on 25.09.17.
//  Copyright © 2017 gr.ia. All rights reserved.
//

import Charts
import UIKit
import Viperit

// MARK: CandleStickView Class
final class CandleStickView: UserInterface {
  @IBOutlet private weak var chartView: CandleStickChartView!

  private let dateFormatter = AxisDateTimeFormatter()
}

// MARK: - CandleStickView API
extension CandleStickView: CandleStickViewApi {
  func setup() {
    chartView.chartDescription?.enabled = false
    chartView.pinchZoomEnabled = false
    chartView.keepPositionOnRotation = true
    chartView.scaleYEnabled = false
    chartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
    chartView.noDataText = displayData.noDataText

    let legend = chartView.legend
    legend.horizontalAlignment = .left
    legend.verticalAlignment = .bottom
    legend.textColor = displayData.textColor

    let xAxis = chartView.xAxis
    xAxis.valueFormatter = dateFormatter
    xAxis.labelPosition = .bottom
    xAxis.labelCount = displayData.xAxisLabelCount
    xAxis.spaceMin = 40
    xAxis.spaceMax = 40
    xAxis.granularityEnabled = true
    xAxis.labelTextColor = displayData.textColor

    chartView.leftAxis.labelTextColor = displayData.textColor
    chartView.rightAxis.enabled = false

    chartView.backgroundColor = displayData.backgroundColor
  }

  func update(data: [CandleChartDataEntry], label: String) {
    guard !data.isEmpty else { return }

    updateFormatter(firstCandle: data.first!, lastCandle: data.last!)

    let chartDataSet = CandleChartDataSet(values: data, label: label)
    chartDataSet.axisDependency = .left
    chartDataSet.decreasingColor = displayData.decreasingColor
    chartDataSet.increasingColor = displayData.increasingColor
    chartDataSet.neutralColor = displayData.neutralColor
    chartDataSet.shadowColorSameAsCandle = true
    chartDataSet.drawValuesEnabled = false

    chartDataSet.barWidth = 20
    chartDataSet.shadowWidth = 4

    chartView.data = CandleChartData(dataSet: chartDataSet)
  }

  private func updateFormatter(firstCandle: CandleChartDataEntry, lastCandle: CandleChartDataEntry) {
    let firstDate = Date(timeIntervalSince1970: firstCandle.x)
    let lastDate = Date(timeIntervalSince1970: lastCandle.x)
    let isSameDay = Date.isSameDay(lhs: firstDate, rhs: lastDate)
    dateFormatter.displayFormat = isSameDay ? .time : [.time, .date]
  }
}

// MARK: - CandleStickView Viper Components API
private extension CandleStickView {
  var presenter: CandleStickPresenterApi {
    return _presenter as! CandleStickPresenterApi
  }

  var displayData: CandleStickDisplayData {
    return _displayData as! CandleStickDisplayData
  }
}
