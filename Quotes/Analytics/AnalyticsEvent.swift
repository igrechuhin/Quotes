//
//  AnalyticsEvent.swift
//  Quotes
//
//  Created by Ilya Grechuhin on 26.09.17.
//  Copyright © 2017 gr.ia. All rights reserved.
//

import Foundation

enum AnalyticsEvent {
  case databaseOpenned(String)
  case quotesConnect
  case quotesDisconnect
  case quotesDidConnect
  case quotesDidDisconnect
  case quotesSubscribe(Set<QuotesSymbol>)
  case quotesUnsubscribe(Set<QuotesSymbol>)
  case quotesTick(String)

  var name: String {
    switch self {
    case .databaseOpenned: return "databaseOpenned"
    case .quotesConnect: return "quotesConnect"
    case .quotesDisconnect: return "quotesDisconnect"
    case .quotesDidConnect: return "quotesDidConnect"
    case .quotesDidDisconnect: return "quotesDidDisconnect"
    case .quotesSubscribe: return "quotesSubscribe"
    case .quotesUnsubscribe: return "quotesUnsubscribe"
    case .quotesTick: return "quotesTick"
    }
  }

  var attributes: [String: Any]? {
    switch self {
    case let .databaseOpenned(fileURL): return ["url": fileURL]
    case .quotesConnect: return nil
    case .quotesDisconnect: return nil
    case .quotesDidConnect: return nil
    case .quotesDidDisconnect: return nil
    case let .quotesSubscribe(symbols): return ["symbol": symbols]
    case let .quotesUnsubscribe(symbols): return ["symbol": symbols]
    case let .quotesTick(tick): return ["tick": tick]
    }
  }
}
