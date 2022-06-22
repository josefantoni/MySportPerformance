//
//  SportActivity.swift
//  MySportPerformance
//
//  Created by Pepca on 22.06.2022.
//

import Foundation

struct SportActivity: Codable {
    let id: UUID
    let name: String
    let created: Double
    let duration: Double
    
    init(dictionary: [String: Any]) throws {
        self = try JSONDecoder().decode(SportActivity.self, from: JSONSerialization.data(withJSONObject: dictionary))
    }
}
