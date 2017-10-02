//
//  CandleStickPresenter.swift
//  Quotes
//
//  Created by Ilya Grechuhin on 25.09.17.
//  Copyright © 2017 gr.ia. All rights reserved.
//

import Charts
import RealmSwift
import RxRealm
import RxSwift
import Viperit

// MARK: - CandleStickPresenter Class
final class CandleStickPresenter: Presenter {
  typealias Candle = Quotes.Config.Candle

  private let disposeBag = DisposeBag()
  private var dataSubscription: Disposable?

  private var chartData: [CandleChartDataEntry] = []

  override func viewHasLoaded() {
    super.viewHasLoaded()
    view.setup()
    updateDataSubscription()
  }

  private func updateChartData(results: AnyRealmCollection<DatabaseCandle>, changes: RealmChangeset) {
    changes.updated
      .map { results[$0] }
      .forEach { candle in
        if let chartIndex = chartData.index(where: { $0.x == candle.date.timeIntervalSince1970 }) {
          chartData[chartIndex] = CandleChartDataEntry(databaseCandle: candle)
        }
      }

    changes.inserted
      .map { results[$0] }
      .forEach { candle in
        chartData.append(CandleChartDataEntry(databaseCandle: candle))
      }
  }

  private func buildInitialChartData(results: AnyRealmCollection<DatabaseCandle>) {
    chartData = results.map({ candle -> CandleChartDataEntry in
      CandleChartDataEntry(databaseCandle: candle)
    })
  }
}

// MARK: - CandleStickPresenter API
extension CandleStickPresenter: CandleStickPresenterApi {
  func updateDataSubscription() {
    dataSubscription?.dispose()
    dataSubscription = interactor.dataChangeSet?
      .subscribe(onNext: { [weak self] results, changes in
        guard let sSelf = self else { return }
        if let changes = changes {
          sSelf.updateChartData(results: results, changes: changes)
        } else {
          sSelf.buildInitialChartData(results: results)
        }
        let label: String
        if let last = results.last {
          label = String(format: "\(last.symbol) (%.2f)", last.close.value!)
        } else {
          label = ""
        }
        sSelf.view.update(data: sSelf.chartData, label: label)
      })
    dataSubscription?.disposed(by: disposeBag)
  }
}

// MARK: - CandleStick Viper Components
private extension CandleStickPresenter {
  var view: CandleStickViewApi {
    return _view as! CandleStickViewApi
  }

  var interactor: CandleStickInteractorApi {
    return _interactor as! CandleStickInteractorApi
  }

  var router: CandleStickRouterApi {
    return _router as! CandleStickRouterApi
  }
}
