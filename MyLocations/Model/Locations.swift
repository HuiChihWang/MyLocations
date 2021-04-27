//
//  Locations.swift
//  MyLocations
//
//  Created by Hui Chih Wang on 2021/4/26.
//

import Foundation
import CoreLocation
import CoreData
import UIKit

class Locations {
    
    private var container: NSPersistentContainer {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer
    }
    
    private var mapTypeLocations = [Category: [LocationMeta]]()
    
    private var categories: [Category] {
        Array(mapTypeLocations.keys)
    }
        
    var numberOfType: Int {
        categories.count
    }
    
    init() {
        loadLocations()
    }
    
    private func loadLocations() {
        let request = NSFetchRequest<Location>(entityName: "Location")
        
        do {
            let locations = try container.viewContext.fetch(request)
            parseLocatitonsToModel(with: locations)
            
        } catch {
            fatalError("\(error)")
        }
    }
    
    private func parseLocatitonsToModel(with locactions: [Location]) {
        locactions.forEach { location in
            let locationMeta = location.toLocationMeta()
            self.addLocation(with: locationMeta)
        }
    }
    
    
    func getCategory(by index: Int) -> Category? {
        (0..<numberOfType).contains(index) ? categories[index] : nil
    }
    
    func getLocationsCountByCategory(with category: Category) -> Int {
        return mapTypeLocations[category]?.count ?? 0
    }
    
    
    public func addLocation(with location: LocationMeta) {
        if mapTypeLocations[location.category] == nil {
            mapTypeLocations[location.category] = [LocationMeta]()
        }
        
        mapTypeLocations[location.category]?.append(location)
        let locationCore = location.toLocation(context: container.viewContext)
        location.locationCore = locationCore
        
        if let data = location.imageData {
            location.locationCore?.saveImage(with: data)
        }
    }
    
    private func checkCategoryChanged(with location: LocationMeta) -> Bool {
        if let locations = mapTypeLocations[location.category], locations.contains(where: {$0.id == location.id}) {
            return false
        }
        
        return true
    }
    
    public func updateLocation(with locationUpdate: LocationMeta) {
        
        if checkCategoryChanged(with: locationUpdate) {
            
            // move location update to correct key position
            mapTypeLocations.forEach { category, locations in
                if let index = locations.firstIndex(where: {$0.id == locationUpdate.id}) {
                    mapTypeLocations[category]?.remove(at: index)
                    
                    if let locations = mapTypeLocations[category], locations.isEmpty {
                        mapTypeLocations[category] = nil
                    }
                }
            }

            
            if mapTypeLocations[locationUpdate.category] == nil {
                mapTypeLocations[locationUpdate.category] = [LocationMeta]()
            }
            
            
            mapTypeLocations[locationUpdate.category]?.append(locationUpdate)
        }
        
        if let data = locationUpdate.imageData {
            locationUpdate.locationCore?.saveImage(with: data)
        }

    }
        
    public func removeLocation(with location: LocationMeta) {
        if var locations = mapTypeLocations[location.category], let index = locations.firstIndex(where: {$0.id == location.id}){
            
            if let locationCore = locations[index].locationCore {
                locationCore.deleteImage()
                container.viewContext.delete(locationCore)
            }

            locations.remove(at: index)
            mapTypeLocations[location.category] = locations.isEmpty ? nil : locations
        }
    }
    
    public func getLocation(in category: Category, with index: Int) -> LocationMeta? {
        guard (0..<getLocationsCountByCategory(with: category)).contains(index) else {
            return nil
        }
        
        return mapTypeLocations[category]?[index]
    }

    private func sortLocations() {
        
    }
}
