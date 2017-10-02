//
//  CandleStickInteractor.swift
//  Quotes
//
//  Created by Ilya Grechuhin on 25.09.17.
//  Copyright © 2017 gr.ia. All rights reserved.
//

import RealmSwift
import RxRealm
import RxSwift
import Viperit

// MARK: - CandleStickInteractor Class
final class CandleStickInteractor: Interactor {
  typealias Candle = Quotes.Config.Candle

  private var symbol: QuotesSymbol?
  private var storage: Database.Storage?

  private var networkQuotes: NetworkQuotes!
  private var syncManager: SyncManager<Candle>!
}

// MARK: - CandleStickInteractor API
extension CandleStickInteractor: CandleStickInteractorApi {
  var dataChangeSet: Observable<(AnyRealmCollection<DatabaseCandle>, RealmChangeset?)>? {
    guard let symbol = symbol, let storage = storage else { return nil }
    let realm = try! Database.instance(storage: storage)
    let candles = Candle.candles(realm: realm, symbol: symbol.rawValue)
    return Observable.changeset(from: candles)
  }

  func setup(symbol: QuotesSymbol, storage: Database.Storage) {
    self.symbol = symbol
    self.storage = storage

    networkQuotes = ExnessQuotes()
    networkQuotes.symbols = [symbol]
    syncManager = SyncManager<Candle>(networkQuotes: networkQuotes, storage: storage)

    presenter.updateDataSubscription()
  }
}

// MARK: - Interactor Viper Components Api
private extension CandleStickInteractor {
  var presenter: CandleStickPresenterApi {
    return _presenter as! CandleStickPresenterApi
  }
}
