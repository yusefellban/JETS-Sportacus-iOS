//
//  CoreDataManager.swift
//  sportacus
//
//  Created by Antigravity on 06/06/2026.
//

import Foundation
import CoreData
import UIKit

class CoreDataManager {
    static let shared = CoreDataManager()
    
    private init() {}
    
    private var context: NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    // MARK: - Create
    
    func addFavourite(league: League, sport: Sport) {
        // Avoid duplicates
        guard !isFavourite(leagueKey: league.leagueKey) else { return }
        
        let entity = FavouriteLeague(context: context)
        entity.leagueKey = league.leagueKey
        entity.leagueName = league.leagueName
        entity.leagueLogo = league.leagueLogo
        entity.countryName = league.countryName
        entity.sportName = sport.rawValue
        
        saveContext()
    }
    
    // MARK: - Read
    
    func fetchAllFavourites() -> [FavouriteLeague] {
        let request: NSFetchRequest<FavouriteLeague> = FavouriteLeague.fetchRequest()
        
        do {
            return try context.fetch(request)
        } catch {
            print("Error fetching favourites: \(error.localizedDescription)")
            return []
        }
    }
    
    func isFavourite(leagueKey: Int64) -> Bool {
        let request: NSFetchRequest<FavouriteLeague> = FavouriteLeague.fetchRequest()
        request.predicate = NSPredicate(format: "leagueKey == %lld", leagueKey)
        request.fetchLimit = 1
        
        do {
            let count = try context.count(for: request)
            return count > 0
        } catch {
            print("Error checking favourite: \(error.localizedDescription)")
            return false
        }
    }
    
    // MARK: - Delete
    
    func removeFavourite(leagueKey: Int64) {
        let request: NSFetchRequest<FavouriteLeague> = FavouriteLeague.fetchRequest()
        request.predicate = NSPredicate(format: "leagueKey == %lld", leagueKey)
        
        do {
            let results = try context.fetch(request)
            for object in results {
                context.delete(object)
            }
            saveContext()
        } catch {
            print("Error removing favourite: \(error.localizedDescription)")
        }
    }
    
    func deleteAllFavourites() {
        let request: NSFetchRequest<NSFetchRequestResult> = FavouriteLeague.fetchRequest()
        let batchDelete = NSBatchDeleteRequest(fetchRequest: request)
        
        do {
            try context.execute(batchDelete)
            saveContext()
        } catch {
            print("Error deleting all favourites: \(error.localizedDescription)")
        }
    }
    
    
    // MARK: - Onboarding
    
    func setOnboardingCompleted() {
        let request: NSFetchRequest<OnboardingStatus> = OnboardingStatus.fetchRequest()
        
        do {
            let results = try context.fetch(request)
            if let existing = results.first {
                existing.hasCompleted = true
            } else {
                let status = OnboardingStatus(context: context)
                status.hasCompleted = true
            }
            saveContext()
        } catch {
            print("Error setting onboarding status: \(error.localizedDescription)")
        }
    }
    
    func isOnboardingCompleted() -> Bool {
        let request: NSFetchRequest<OnboardingStatus> = OnboardingStatus.fetchRequest()
        request.fetchLimit = 1
        
        do {
            let results = try context.fetch(request)
            return results.first?.hasCompleted ?? false
        } catch {
            print("Error checking onboarding status: \(error.localizedDescription)")
            return false
        }
    }
    
    // MARK: - Save
    
    private func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Error saving CoreData context: \(error.localizedDescription)")
            }
        }
    }
}
