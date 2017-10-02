//
//  NetworkQuotesTick.swift
//  Quotes
//
//  Created by Ilya Grechuhin on 26.09.17.
//  Copyright © 2017 gr.ia. All rights reserved.
//

import Foundation

struct NetworkQuotesTick: Decodable {
  let symbol: String
  let bid: Float
  let date = Date()

  private enum CodingKeys: String, CodingKey {
    case symbol = "s"
    case bid = "b"
  }

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    symbol = try container.decode(String.self, forKey: .symbol)
    let bidString = try container.decode(String.self, forKey: .bid)
    if let bid = Float(bidString) {
      self.bid = bid
    } else {
      throw AnalyticsError.networkQuotesInvalidFloat(bidString)
    }
  }
}

struct NetworkQuotesTicks: Decodable {
  let ticks: [NetworkQuotesTick]?
}

struct NetworkQuotesSubscriptionInfo: Decodable {
  let subscribedCount: Int
  let subscribedList: NetworkQuotesTicks?

  private enum CodingKeys: String, CodingKey {
    case subscribedCount = "subscribed_count"
    case subscribedList = "subscribed_list"
  }
}
