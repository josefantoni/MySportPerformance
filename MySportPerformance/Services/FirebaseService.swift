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
    func addRemoteSportActivity(sportActivity: SportActivity) -> AnyPublisher<Never, Error>
    func removeRemoteSportActivity(documentId: String) -> AnyPublisher<Never, Error>
}

final class FirebaseService: FirebaseServiceProtocol {
    func fetchRemoteActivities() -> AnyPublisher<[SportActivity], Error> {
        return Future<[SportActivity], Error> { promise in
            Firestore.firestore().collection(PersistentStore.retrieveAppUUID())
                .getDocuments { querySnapshot, error in
                if let err = error {
                    return promise(.failure(err))
                } else if let documents = querySnapshot?.documents {
                    let fetchedActivities: [SportActivity]  = documents.map { documentSnapshot in
                        // TODO: cleaner solution
                        try! SportActivity(document: documentSnapshot)
                    }
                    return promise(.success(fetchedActivities))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func addRemoteSportActivity(sportActivity: SportActivity) -> AnyPublisher<Never, Error> {
        return Future<Never, Error> { promise in
            Firestore.firestore().collection(PersistentStore.retrieveAppUUID())
                .addDocument(data: [
                    "id": sportActivity.id.description,
                    "place": sportActivity.place,
                    "created": sportActivity.created,
                    "name": sportActivity.name,
                    "duration": sportActivity.duration
                ]) { err in
                    if let err = err {
                        return promise(.failure(err))
                    }
                }
        }.eraseToAnyPublisher()
    }
    
    func removeRemoteSportActivity(documentId: String) -> AnyPublisher<Never, Error> {
        return Future<Never, Error> { promise in
            Firestore.firestore().collection(PersistentStore.retrieveAppUUID())
                .document(documentId).delete() { err in
                    if let err = err {
                        print("Error removing document: \(err)")
                    } else {
                        print("Document successfully removed!")
                    }
                }
        }.eraseToAnyPublisher()
    }
}
