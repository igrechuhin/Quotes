//
//  FabricAnalyticsService.swift
//  Quotes
//
//  Created by Ilya Grechuhin on 26.09.17.
//  Copyright © 2017 gr.ia. All rights reserved.
//

import Crashlytics
import Fabric
import UIKit

final class FabricAnalyticsService: AnalyticsService {
  static func setup(application _: UIApplication, launchOptions _: [UIApplicationLaunchOptionsKey: Any]?) {
    Config.setup(development: {
      Fabric.sharedSDK().debug = true
      Crashlytics.sharedInstance().debugMode = true
    }, production: {
      Fabric.sharedSDK().debug = false
      Crashlytics.sharedInstance().debugMode = false
    })
    Fabric.with([Crashlytics.self])
  }

  static func setUserIdentifier(_ identifier: String) {
    Crashlytics.sharedInstance().setUserIdentifier(identifier)
  }

  static func setUserName(_ userName: String) {
    Crashlytics.sharedInstance().setUserIdentifier(userName)
  }

  static func setUserEmail(_ userEmail: String) {
    Crashlytics.sharedInstance().setUserIdentifier(userEmail)
  }

  static func track(event: AnalyticsEvent) {
    Answers.logCustomEvent(withName: event.name, customAttributes: event.attributes)
  }

  static func track(error: Swift.Error) {
    Crashlytics.sharedInstance().recordError(error)
  }
}
