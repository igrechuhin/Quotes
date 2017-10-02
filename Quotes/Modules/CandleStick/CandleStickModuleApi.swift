//
//  CandleStickModuleApi.swift
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

// MARK: - CandleStickRouter API
protocol CandleStickRouterApi: RouterProtocol {
}

// MARK: - CandleStickView API
protocol CandleStickViewApi: UserInterfaceProtocol {
  func setup()
  func update(data: [CandleChartDataEntry], label: String)
}

// MARK: - CandleStickPresenter API
protocol CandleStickPresenterApi: PresenterProtocol {
  func updateDataSubscription()
}

// MARK: - CandleStickInteractor API
protocol CandleStickInteractorApi: InteractorProtocol {
  var dataChangeSet: Observable<(AnyRealmCollection<DatabaseCandle>, RealmChangeset?)>? { get }

  func setup(symbol: QuotesSymbol, storage: Database.Storage)
}
