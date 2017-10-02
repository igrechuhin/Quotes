//
//  NetworkQuotesProtocol.swift
//  Quotes
//
//  Created by Ilya Grechuhin on 27.09.17.
//  Copyright © 2017 gr.ia. All rights reserved.
//

import RxSwift

protocol NetworkQuotes: class {
  var ticks: PublishSubject<[NetworkQuotesTick]> { get }
  var symbols: Set<QuotesSymbol> { get set }
}
