//
//  AnalyticsService.swift
//  Quotes
//
//  Created by Ilya Grechuhin on 26.09.17.
//  Copyright © 2017 gr.ia. All rights reserved.
//

import UIKit

protocol AnalyticsService: class {
  static func setup(application: UIApplication, launchOptions: [UIApplicationLaunchOptionsKey: Any]?)

  static func setUserIdentifier(_ identifier: String)
  static func setUserName(_ userName: String)
  static func setUserEmail(_ userEmail: String)

  static func track(event: AnalyticsEvent)
  static func track(error: Error)

  static func shouldTrack(event: AnalyticsEvent) -> Bool
}

// Default behavior
extension AnalyticsService {
  static func setUserIdentifier(_: String) {}
  static func setUserName(_: String) {}
  static func setUserEmail(_: String) {}

  static func shouldTrack(event _: AnalyticsEvent) -> Bool {
    return true
  }
}
