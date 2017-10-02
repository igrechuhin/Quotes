//
//  Analytics.swift
//  Quotes
//
//  Created by Ilya Grechuhin on 26.09.17.
//  Copyright © 2017 gr.ia. All rights reserved.
//

import UIKit

final class Analytics: AnalyticsService {
  private static let services: [AnalyticsService.Type] =
    Config.alternative(development: [LoggingAnalyticsService.self],
                       production: [FabricAnalyticsService.self])

  static var testMode = false

  private static func perform(block: () -> Void) {
    guard !testMode else { return }
    block()
  }

  static func setup(application: UIApplication, launchOptions: [UIApplicationLaunchOptionsKey: Any]?) {
    perform {
      services
        .forEach { $0.setup(application: application, launchOptions: launchOptions) }
    }
  }

  static func setUserIdentifier(_ identifier: String) {
    perform {
      services
        .forEach { $0.setUserIdentifier(identifier) }
    }
  }

  static func setUserName(_ userName: String) {
    perform {
      services
        .forEach { $0.setUserName(userName) }
    }
  }

  static func setUserEmail(_ userEmail: String) {
    perform {
      services
        .forEach { $0.setUserEmail(userEmail) }
    }
  }

  static func track(event: AnalyticsEvent) {
    perform {
      services
        .filter { $0.shouldTrack(event: event) }
        .forEach { $0.track(event: event) }
    }
  }

  static func track(error: Error) {
    perform {
      services
        .forEach { $0.track(error: error) }
    }
  }
}
