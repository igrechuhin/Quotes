//
//  CandleStickRouter.swift
//  Quotes
//
//  Created by Ilya Grechuhin on 25.09.17.
//  Copyright © 2017 gr.ia. All rights reserved.
//

import Viperit

// MARK: - CandleStickRouter class
final class CandleStickRouter: Router {
}

// MARK: - CandleStickRouter API
extension CandleStickRouter: CandleStickRouterApi {
}

// MARK: - CandleStick Viper Components
private extension CandleStickRouter {
  var presenter: CandleStickPresenterApi {
    return _presenter as! CandleStickPresenterApi
  }
}
