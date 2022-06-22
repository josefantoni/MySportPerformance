//
//  FirebaseService.swift
//  MySportPerformance
//
//  Created by Pepca on 22.06.2022.
//

import Foundation
import Combine
import FirebaseCore
import FirebaseFirestore

protocol FirebaseServiceProtocol {
    func fetchRemoteActivities() -> AnyPublisher<[SportActivity], Error>
    func addRemoteSportActivity(name: String,
                                duration: Double) -> AnyPublisher<Never, Error>
}

final class FirebaseService: FirebaseServiceProtocol {
    // Remote storage
    private let sportActivityRemoteModel = "SportActivityRemoteModel"

    func fetchRemoteActivities() -> AnyPublisher<[SportActivity], Error> {
        return Future<[SportActivity], Error> { promise in
            Firestore.firestore().collection(self.sportActivityRemoteModel)
                .getDocuments { querySnapshot, error in
                if let err = error {
                    return promise(.failure(err))
                } else if let documents = querySnapshot?.documents {
                    let fetchedActivities: [SportActivity]  = documents.map { documentSnapshot in
                        try! SportActivity(dictionary: documentSnapshot.data())
                    }
                    return promise(.success(fetchedActivities))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func addRemoteSportActivity(name: String,
                                duration: Double) -> AnyPublisher<Never, Error> {
        return Future<Never, Error> { promise in
            Firestore.firestore().collection(self.sportActivityRemoteModel)
                .addDocument(data: [
                    "id": UUID().description,
                    "created": Date().timeIntervalSince1970,
                    "name": name,
                    "duration": duration,
                ]) { err in
                    if let err = err {
                        return promise(.failure(err))
                    } 
                }
        }.eraseToAnyPublisher()
        
    }
}
