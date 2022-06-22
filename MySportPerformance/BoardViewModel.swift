//
//  BoardViewModel.swift
//  MySportPerformance
//
//  Created by Pepca on 21.06.2022.
//

import Foundation
import Combine
import CoreData

final class BoardViewModel: ObservableObject {
    // Local storage
    private let sportActivityModel = "SportActivityModel"
    private let sportActivityEntity = "SportActivityEntity"

    let container: NSPersistentContainer
    @Published var storedSportActivities: [SportActivityEntity] = []
    @Published var sportActivities: [SportActivity] = []
    var bag = Set<AnyCancellable>()
    private let firebaseService: FirebaseServiceProtocol

    init(service: FirebaseServiceProtocol = FirebaseService()) {
        firebaseService = service
        container = NSPersistentContainer(name: sportActivityModel)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // we can migrate in later phase of project
                fatalError("Error loading data: \(error)")
            } else {
                print("Data were loaded!")
            }
        })
        fetchLocalSportActivities()
        fetchRemoteData()
    }

    func addSportActivity(name: String,
                          duration: Double,
                          isLocalType: Bool = false) {
        if isLocalType {
            addLocalSportActivity(name: name,
                                  duration: duration)
        } else {
            addRemoteSportActivity(name: name,
                                   duration: duration)
        }
    }
    
    // Local data
    private func addLocalSportActivity(name: String,
                          duration: Double) {
        let activity = SportActivityEntity(context: container.viewContext)
        activity.id = UUID()
        activity.created = Date().timeIntervalSince1970
        activity.name = name
        activity.duration = duration
        storedSportActivities.append(activity)
        saveToDb()
    }
    
    func removeSportActivity(by indexSet: IndexSet) {
        if let index = indexSet.first {
            let activityToDelete = self.storedSportActivities[index]
            container.viewContext.delete(activityToDelete)
            storedSportActivities.remove(at: index)
            saveToDb()
        }
    }
    
    private func fetchLocalSportActivities() {
        let request = NSFetchRequest<SportActivityEntity>(entityName: sportActivityEntity)
        do {
            storedSportActivities = try container.viewContext.fetch(request)
        } catch let error {
            fatalError("Something went wrong while fetching sport activities: \(error)")
        }
    }
    
    func saveToDb() {
        do {
            try container.viewContext.save()
            print("Save was sucessfull")
        } catch let error {
            fatalError("Something went wrong white saving to DB:  \(error)")
        }
    }
    
    // Remote data
    private func addRemoteSportActivity(name: String,
                                        duration: Double) {
        firebaseService.addRemoteSportActivity(name: name,
                                               duration: duration).sink { completion in
            switch completion {
            case .finished:
                print("A new activity was created on server!")
            case .failure(let err):
                print("Error sending new activity: \(err)")
            }
        } receiveValue: { _ in }
        .store(in: &bag)
    }
    
    private func fetchRemoteData() {
        firebaseService.fetchRemoteActivities().sink { completion in
            switch completion {
            case .finished:
                print("Documents were fetched!")
            case .failure(let err):
                print("Error getting documents: \(err)")
            }
        } receiveValue: { [weak self] sportsActivities in
            self?.sportActivities = sportsActivities
        }.store(in: &bag)
    }
}
