//
//  DB.swift
//  Quotes
//
//  Created by Ilya Grechuhin on 25.09.17.
//  Copyright © 2017 gr.ia. All rights reserved.
//

import RealmSwift

enum Database {
  private enum Config {
    static let keyName = "gr.ia.Quotes.Database.Queue"
    static let inMemoryIdentifier = "gr.ia.Quotes.Database"
  }

  enum Storage {
    case persistent
    case inMemory

    func objectTypes() -> [Object.Type] {
      return [DatabaseCandle1M.self]
    }

    func configuration() -> Realm.Configuration {
      switch self {
      case .persistent:
        var encryptionKey: Data?
        let schemaVersion: UInt64 = 0
        var migrationBlock: MigrationBlock?
        var deleteRealmIfMigrationNeeded = false

        Quotes.Config.setup(development: {
          encryptionKey = nil
          deleteRealmIfMigrationNeeded = true
          migrationBlock = nil
        }, production: {
          assert(false, "Update implementation")
          encryptionKey = nil
          deleteRealmIfMigrationNeeded = true
          migrationBlock = nil
        })

        return Realm.Configuration(encryptionKey: encryptionKey,
                                   schemaVersion: schemaVersion,
                                   migrationBlock: migrationBlock,
                                   deleteRealmIfMigrationNeeded: deleteRealmIfMigrationNeeded,
                                   objectTypes: objectTypes())
      case .inMemory:
        return Realm.Configuration(inMemoryIdentifier: Config.inMemoryIdentifier,
                                   objectTypes: objectTypes())
      }
    }
  }

  private static let processQueue = DispatchQueue(label: Config.keyName)

  static func instance(storage: Storage = Quotes.Config.storage()) throws -> Realm {
    return try Realm(configuration: storage.configuration())
  }

  static func write(storage: Storage = Quotes.Config.storage(), block: @escaping ((Realm) throws -> Void)) throws {
    try processQueue.sync {
      do {
        let db = try Database.instance(storage: storage)
        try db.write {
          try block(db)
        }
      } catch let error {
        Analytics.track(error: error)
        throw error
      }
    }
  }

  static func setup(application _: UIApplication, launchOptions _: [UIApplicationLaunchOptionsKey: Any]?) {
    // Will make migration here, if required
    let realm = try! instance()
    Analytics.track(event: .databaseOpenned(realm.configuration.fileURL?.absoluteString ?? "inMemory"))
  }
}
