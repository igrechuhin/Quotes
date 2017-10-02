//
//  AnalyticsError.swift
//  Quotes
//
//  Created by Ilya Grechuhin on 26.09.17.
//  Copyright © 2017 gr.ia. All rights reserved.
//

import Foundation

enum AnalyticsError: Error {
  case networkQuotesInvalidJSON(String)
  case networkQuotesInvalidFloat(String)

  var name: String {
    switch self {
    case .networkQuotesInvalidJSON: return "networkQuotesInvalidJSON"
    case .networkQuotesInvalidFloat: return "networkQuotesInvalidFloat"
    }
  }

  var attributes: [String: Any]? {
    switch self {
    case let .networkQuotesInvalidJSON(text): return ["text": text]
    case let .networkQuotesInvalidFloat(text): return ["text": text]
    }
  }
}
