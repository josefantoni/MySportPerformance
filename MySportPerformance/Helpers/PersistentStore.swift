//
//  PersistentStore.swift
//  MySportPerformance
//
//  Created by Pepca on 22.06.2022.
//

import Foundation

class PersistentStore {
    static func retrieveAppUUID() -> String {
        if let appuuid = UserDefaults.standard.object(forKey: "AppUUID") as? String {
            return appuuid
        } else {
            let uuid = UUID().description
            UserDefaults.standard.set(uuid, forKey: "AppUUID")
            return uuid
        }
    }
}
