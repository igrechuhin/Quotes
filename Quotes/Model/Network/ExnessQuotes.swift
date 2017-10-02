//
//  NetworkQuotes.swift
//  Quotes
//
//  Created by Ilya Grechuhin on 26.09.17.
//  Copyright © 2017 gr.ia. All rights reserved.
//

import RxSwift
import Starscream

final class ExnessQuotes: NetworkQuotes {
  private enum Config {
    static let processQueueLabel = "gr.ia.Quotes.ExnessQuotes.Queue"
    static let processQueueKey = DispatchSpecificKey<()>()

    static let socketURL = URL(string: "wss://quotes.exness.com:18400")!

    private static func symbolsString(_ symbols: Set<QuotesSymbol>) -> String {
      return symbols.map { $0.rawValue }.joined(separator: ",")
    }

    static func subscribeRequest(symbols: Set<QuotesSymbol>) -> String {
      return "SUBSCRIBE: \(symbolsString(symbols))"
    }

    static func unsubscribeRequest(symbols: Set<QuotesSymbol>) -> String {
      return "UNSUBSCRIBE: \(symbolsString(symbols))"
    }
  }

  private enum Packet {
    case subscriptionInfo
    case ticks
  }

  let ticks = PublishSubject<[NetworkQuotesTick]>()
  var symbols: Set<QuotesSymbol> = [] {
    willSet {
      unsubscribe()
    }
    didSet {
      if socket.isConnected {
        subscribe()
      } else {
        connect()
      }
    }
  }

  private var expectedPacket = Packet.subscriptionInfo

  private let socket = WebSocket(url: Config.socketURL)
  private static let processQueue: DispatchQueue = {
    let queue = DispatchQueue(label: Config.processQueueLabel, qos: .utility)
    queue.setSpecific(key: Config.processQueueKey, value: ())
    return queue
  }()

  init() {
    socket.delegate = self
    socket.callbackQueue = ExnessQuotes.processQueue
    connect()
    subscribeToAppStateChanges()
  }

  deinit {
    disconnect()
    ticks.onCompleted()
  }

  private func subscribeToAppStateChanges() {
    let nc = NotificationCenter.default
    nc.addObserver(self, selector: #selector(connect), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)

    // No need to disconnect. No ticks will arrive in background.
    // If connection is lost while in background the app will reconnect on UIApplicationDidBecomeActive
    // However, I consider it to be the true way to release resources we can not use.
    nc.addObserver(self, selector: #selector(disconnect), name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)

    // No removeObserver since:
    // If your app targets iOS 9.0 and later or macOS 10.11 and later, you don't need to unregister
    // an observer in its deallocation method. If your app targets earlier releases, be sure to invoke
    // removeObserver(_:name:object:) before observer or any object specified in
    // addObserver:selector:name:object: is deallocated.
  }

  @objc private func connect() {
    ExnessQuotes.processQueue.async {
      if !self.socket.isConnected {
        Analytics.track(event: .quotesConnect)
        self.socket.connect()
      }
    }
  }

  @objc private func disconnect() {
    Analytics.track(event: .quotesDisconnect)
    unsubscribe()
    ExnessQuotes.processQueue.safeSync(token: Config.processQueueKey) {
      socket.disconnect()
    }
  }

  private func subscribe() {
    ExnessQuotes.processQueue.async {
      guard !self.symbols.isEmpty else { return }
      Analytics.track(event: .quotesSubscribe(self.symbols))
      self.socket.write(string: Config.subscribeRequest(symbols: self.symbols)) { [weak self] in
        self?.expectedPacket = .subscriptionInfo
      }
    }
  }

  private func unsubscribe() {
    ExnessQuotes.processQueue.safeSync(token: Config.processQueueKey) {
      guard !symbols.isEmpty else { return }
      Analytics.track(event: .quotesUnsubscribe(symbols))
      socket.write(string: Config.unsubscribeRequest(symbols: symbols)) { [weak self] in
        self?.expectedPacket = .subscriptionInfo
      }
    }
  }

  private func parseSubscription(data: Data) {
    expectedPacket = .ticks
    ExnessQuotes.processQueue.async {
      do {
        let info = try JSONDecoder().decode(NetworkQuotesSubscriptionInfo.self, from: data)
        if let ticks = info.subscribedList?.ticks {
          self.ticks.onNext(ticks)
        }
      } catch {
        self.parseTicks(data: data)
      }
    }
  }

  private func parseTicks(data: Data) {
    ExnessQuotes.processQueue.async {
      do {
        if let ticks = try JSONDecoder().decode(NetworkQuotesTicks.self, from: data).ticks {
          self.ticks.onNext(ticks)
        }
      } catch {
        Analytics.track(error: error)
      }
    }
  }
}

extension ExnessQuotes: WebSocketDelegate {
  func websocketDidConnect(socket _: WebSocketClient) {
    Analytics.track(event: .quotesDidConnect)
    subscribe()
  }

  func websocketDidDisconnect(socket _: WebSocketClient, error: Error?) {
    Analytics.track(event: .quotesDidDisconnect)
    if let error = error {
      Analytics.track(error: error)
    }
    connect()
  }

  func websocketDidReceiveMessage(socket _: WebSocketClient, text: String) {
    Analytics.track(event: .quotesTick(text))
    guard let data = text.data(using: .utf8) else {
      Analytics.track(error: AnalyticsError.networkQuotesInvalidJSON(text))
      return
    }
    switch expectedPacket {
    case .subscriptionInfo: parseSubscription(data: data)
    case .ticks: parseTicks(data: data)
    }
  }

  func websocketDidReceiveData(socket _: WebSocketClient, data _: Data) {}
}
