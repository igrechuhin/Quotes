//
//  DispatchQueue+Token.swift
//  Quotes
//
//  Created by Ilya Grechuhin on 01.10.2017.
//  Copyright © 2017 gr.ia. All rights reserved.
//

import Dispatch

extension DispatchQueue {
  func safeSync<T>(token: DispatchSpecificKey<()>, execute work: () throws -> T) rethrows -> T {
    guard let currentSpecific = DispatchQueue.getSpecific(key: token),
      let queueSpecific = getSpecific(key: token) else {
      return try sync(execute: work)
    }

    if currentSpecific == queueSpecific {
      return try work()
    } else {
      return try sync(execute: work)
    }
  }
}
