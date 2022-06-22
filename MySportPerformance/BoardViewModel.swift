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
    private let sportActivityModel = "SportActivityModel"
    private let sportActivityEntity = "SportActivityEntity"

    let container: NSPersistentContainer
    @Published var storedSportActivities: [SportActivityEntity] = []
    
    init() {
        container = NSPersistentContainer(name: sportActivityModel)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Error loading data: \(error)")
            } else {
                print("Data were loaded!")
            }
        })
        fetchStoredSportActivities()
    }
    
    private func fetchStoredSportActivities() {
        let request = NSFetchRequest<SportActivityEntity>(entityName: sportActivityEntity)
        do {
            storedSportActivities = try container.viewContext.fetch(request)
        } catch let error {
            fatalError("Something went wrong while fetching sport activities: \(error)")
        }
    }

    func addSportActivity(name: String,
                          duration: Double) {
        let activity = SportActivityEntity(context: container.viewContext)
        activity.id = UUID()
        activity.created = Date()
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
    
    func saveToDb() {
        do {
            try container.viewContext.save()
            print("Save was sucessfull")
        } catch let error {
            fatalError("Something went wrong white saving to DB:  \(error)")
        }
    }
}
