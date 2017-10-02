//
//  Config.swift
//  Quotes
//
//  Created by Ilya Grechuhin on 26.09.17.
//  Copyright © 2017 gr.ia. All rights reserved.
//

import Foundation

enum Config {
  typealias Candle = DatabaseCandle1M

  static let type = Config.development

  case development
  case production

  static func storage() -> Database.Storage {
    return .inMemory
  }

  static func setup(development: () -> Void, production: () -> Void) {
    switch type {
    case .development: development()
    case .production: production()
    }
  }

  static func alternative<T>(development: @autoclosure () -> T, production: @autoclosure () -> T) -> T {
    switch type {
    case .development: return development()
    case .production: return production()
    }
  }
}
