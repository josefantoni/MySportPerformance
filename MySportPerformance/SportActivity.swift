//
//  SportActivity.swift
//  MySportPerformance
//
//  Created by Pepca on 22.06.2022.
//

import Foundation
import FirebaseFirestore

struct SportActivity: Codable {
    let id: UUID
    let name: String
    let created: Double
    let duration: Double
    var documentId: String?
    
    var isLocalObject: Bool {
        get {
            guard let docId = documentId else {
                return true
            }
            return docId.isEmpty
        }
    }

    init(id: UUID,
         name: String,
         created: Double,
         duration: Double) {
        self.id = id
        self.name = name
        self.created = created
        self.duration = duration
    }
    
    init(entity: SportActivityEntity) {
        self.id = entity.id ?? UUID()
        self.name = entity.name ?? "?"
        self.created = entity.created
        self.duration = entity.duration
    }
    
    init(document: QueryDocumentSnapshot) throws {
        self = try JSONDecoder().decode(SportActivity.self, from: JSONSerialization.data(withJSONObject: document.data()))
        self.documentId = document.documentID
    }
}
