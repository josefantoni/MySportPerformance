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

    private let container: NSPersistentContainer
    private var bag = Set<AnyCancellable>()
    private let firebaseService: FirebaseServiceProtocol

    @Published var allSportActivities: [SportActivity] = []     // all activities
    @Published var sportActivityType: eSportActivityType = .all

    init(service: FirebaseServiceProtocol = FirebaseService()) {
        firebaseService = service
        container = NSPersistentContainer(name: sportActivityModel)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // we can migrate in later phase of project
                fatalError("Error loading data: \(error)")
            }
        })
        refreshSportActivities()
    }
    
    private func refreshSportActivities() {
        let localSportActivities = fetchLocalSportActivities()
        allSportActivities = localSportActivities.map { sportActivityEntity in
            return SportActivity(entity: sportActivityEntity)
        }
        fetchRemoteData()
    }
    
    var filteredSportActivities: [SportActivity] {
        let results = allSportActivities
        switch sportActivityType {
        case .local:
            return results.filter { $0.isLocalObject }
        case .remote:
            return results.filter { !$0.isLocalObject }
        default:
            return results
        }
    }

    func addSportActivity(name: String,
                          duration: Double,
                          isLocalType: Bool) {
        var sportActivity = SportActivity(id: UUID(),
                                     name: name,
                                     created: Date().timeIntervalSince1970,
                                     duration: duration)
        if isLocalType {
            addLocalSportActivity(sportActivity: sportActivity)
        } else {
            sportActivity.documentId = UUID().description
            addRemoteSportActivity(sportActivity: sportActivity)
        }
        allSportActivities.insert(sportActivity, at: 0)
    }
    
    // Local data
    private func addLocalSportActivity(sportActivity: SportActivity) {
        let entity = SportActivityEntity(context: container.viewContext)
        entity.id = sportActivity.id
        entity.created = sportActivity.created
        entity.name = sportActivity.name
        entity.duration = sportActivity.duration
        saveToDb()
    }
    
    func removeSportActivity(by indexSet: IndexSet) {
        if let index = indexSet.first {
            let activityToDelete = filteredSportActivities[index]
            if activityToDelete.isLocalObject {
                let localSportActivities = fetchLocalSportActivities()
                if let localIndex = localSportActivities.firstIndex(where: { $0.id == activityToDelete.id }) {
                    container.viewContext.delete(localSportActivities[localIndex])
                    saveToDb()
                }
            } else {
                if let documentId = activityToDelete.documentId { removeRemoteSportActivity(documentId: documentId) }
            }
            // remember that we show -> filtered activities!
            if let indx = allSportActivities.firstIndex(where: { $0.id == activityToDelete.id }) {
                self.allSportActivities.remove(at: indx)
            }
        }
    }
    
    private func fetchLocalSportActivities() -> [SportActivityEntity] {
        let request = NSFetchRequest<SportActivityEntity>(entityName: sportActivityEntity)
        var storedSportActivities: [SportActivityEntity] = []
        do {
            storedSportActivities = try container.viewContext.fetch(request)
        } catch let error {
            fatalError("Something went wrong while fetching sport activities: \(error)")
        }
        return storedSportActivities
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
    private func addRemoteSportActivity(sportActivity: SportActivity) {
        firebaseService.addRemoteSportActivity(sportActivity: sportActivity).sink { completion in
            switch completion {
            case .finished:
                print("A new sport activity was created on server!")
            case .failure(let err):
                print("Error sending new sport activity: \(err)")
            }
        } receiveValue: { _ in }
        .store(in: &bag)
    }
    
    private func fetchRemoteData() {
        firebaseService.fetchRemoteActivities().sink { completion in
            switch completion {
            case .finished:
                print("Sport activities were fetched!")
            case .failure(let err):
                print("Error getting sport activities: \(err)")
            }
        } receiveValue: { [weak self] sportsActivities in
            guard let self = self else { return }
            self.allSportActivities.append(contentsOf: sportsActivities)
            self.allSportActivities = self.allSportActivities.sorted(by: { $0.created > $1.created })
        }.store(in: &bag)
    }
    
    private func removeRemoteSportActivity(documentId: String) {
        firebaseService.removeRemoteSportActivity(documentId: documentId).sink { completion in
            switch completion {
            case .finished:
                print("Activity was removed!")
            case .failure(let err):
                print("Error white removing sport activity: \(err)")
            }
        } receiveValue: { _ in }
        .store(in: &bag)
    }
}
