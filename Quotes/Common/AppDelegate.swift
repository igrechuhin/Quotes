//
//  AppDelegate.swift
//  Quotes
//
//  Created by Ilya Grechuhin on 25.09.17.
//  Copyright © 2017 gr.ia. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?

  private func setup(_ application: UIApplication, _ launchOptions: [UIApplicationLaunchOptionsKey: Any]?) {
    Analytics.setup(application: application, launchOptions: launchOptions)
    Database.setup(application: application, launchOptions: launchOptions)
  }

  private func showMainWindow() {
    window = UIWindow(frame: UIScreen.main.bounds)
    let module = AppModules.CandleStick.build()
    let interactor = (module.interactor as! CandleStickInteractor)
    interactor.setup(symbol: .BTCUSD, storage: Config.storage())
    module.router.show(inWindow: window)
  }

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    // Prevent app launch during testing to get real code coverage.
    guard ProcessInfo.processInfo.environment["XCInjectBundleInto"] == nil else { return false }

    setup(application, launchOptions)
    showMainWindow()
    return true
  }
}
