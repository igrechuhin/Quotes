//
//  LoggingAnalyticsService.swift
//  Quotes
//
//  Created by Ilya Grechuhin on 26.09.17.
//  Copyright © 2017 gr.ia. All rights reserved.
//

import UIKit

final class LoggingAnalyticsService: AnalyticsService {
  static func setup(application _: UIApplication, launchOptions _: [UIApplicationLaunchOptionsKey: Any]?) {
  }

  static func setUserIdentifier(_ identifier: String) {
    print("UserIdentifier: \(identifier)")
  }

  static func setUserName(_ userName: String) {
    print("UserName: \(userName)")
  }

  static func setUserEmail(_ userEmail: String) {
    print("UserEmail: \(userEmail)")
  }

  static func track(event: AnalyticsEvent) {
    print("Event: \(event.name)")
    if let attributes = event.attributes {
      print("Attributes: \(attributes.description)")
    }
  }

  static func track(error: Swift.Error) {
    print("Error: \(error)")
  }
}
