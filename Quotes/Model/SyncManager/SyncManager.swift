//
//  SyncManager.swift
//  Quotes
//
//  Created by Ilya Grechuhin on 27.09.17.
//  Copyright © 2017 gr.ia. All rights reserved.
//

import RxSwift

final class SyncManager<Candle: DatabaseCandle> {
  private enum Config {
    static var keyName: String { return "gr.ia.Quotes.SyncManager.Queue" }
  }

  private let networkQuotes: NetworkQuotes
  private let disposeBag = DisposeBag()

  init(networkQuotes: NetworkQuotes, storage: Database.Storage = Quotes.Config.storage()) {
    self.networkQuotes = networkQuotes

    networkQuotes.ticks
      .subscribeOn(SerialDispatchQueueScheduler(internalSerialQueueName: Config.keyName))
      .subscribe(onNext: { [storage] ticks in
        try? Database.write(storage: storage) { realm in
          ticks.forEach { tick in
            let candle = Candle.candle(realm: realm, symbol: tick.symbol, date: tick.date)
            candle.append(tick)
            realm.add(candle)
          }
        }
      })
      .disposed(by: disposeBag)
  }
}
