//
//  Candle.swift
//  Quotes
//
//  Created by Ilya Grechuhin on 28.09.2017.
//  Copyright © 2017 gr.ia. All rights reserved.
//

import RealmSwift

class DatabaseCandle: Object {
  @objc dynamic var symbol = ""

  let open = RealmOptional<Float>()
  let high = RealmOptional<Float>()
  let low = RealmOptional<Float>()
  let close = RealmOptional<Float>()

  @objc dynamic var date = Date()

  override static func indexedProperties() -> [String] {
    return ["symbol", "date"]
  }

  func append(_ tick: NetworkQuotesTick) {
    let tp = type(of: self)
    guard tp.stepInterval(date: date) == tp.stepInterval(date: tick.date) else { return }
    let bid = tick.bid
    open.value = open.value ?? bid
    high.value = max(high.value ?? -.infinity, bid)
    low.value = min(low.value ?? .infinity, bid)
    close.value = bid
  }

  class func candles(realm: Realm, symbol: String) -> Results<DatabaseCandle> {
    return realm.objects(self).filter("symbol == %@", symbol).sorted(byKeyPath: "date")
  }

  class func candle(realm: Realm, symbol: String, date: Date) -> DatabaseCandle {
    let minutesIntervalDate = intervalDate(date: date)
    let storedObjects = realm.objects(self).filter("symbol == %@ AND date == %@", symbol, minutesIntervalDate)
    if storedObjects.isEmpty {
      return realm.create(self, value: ["symbol": symbol, "date": minutesIntervalDate])
    }
    assert(storedObjects.count == 1)
    return storedObjects.first!
  }

  class func stepInterval(date: Date) -> Date.StepInterval {
    return date.minutesSince1970
  }

  class func intervalDate(date: Date) -> Date {
    return date.minutesIntervalDate
  }
}
