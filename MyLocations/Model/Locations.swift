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

struct LocationMeta: Identifiable {
    var location: CLLocation = CLLocation()
    var placemark: CLPlacemark?
    var date = Date()
    
    var description = ""
  
    var category = Category.none
        
    var locationCore: Location?
    var photoURL: URL?
    
    
    var address: String {
        placemark?.formattedAddress ?? "Unknown"
    }
    
    var isInCoreData: Bool {
        return locationCore != nil
    }
    
    var id: String {
        description
    }
    

    init(location: CLLocation, placemark: CLPlacemark?) {
        self.location = location
        self.placemark = placemark
    }
    
    init(description: String, category: Category) {
        self.description = description
        self.category = category
    }
    
    func toLocation(context: NSManagedObjectContext) -> Location {
        let location = Location(context: context)
        location.category = category.rawValue
        location.latitude = self.location.coordinate.latitude
        location.longitude = self.location.coordinate.longitude
        location.localDescription = description
        location.placemark = placemark
        location.date = date
        
        return location
    }
}


class Locations {
    
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
        
        if let locations = mapTypeLocations[location.category], !locations.contains(where: {$0.id == location.id}) {
            mapTypeLocations[location.category]?.append(location)
            location.toLocation(context: container.viewContext)
        }
    }
    
    public func updateLocation(with locationUpdate: LocationMeta) {
        var locationOld: LocationMeta?
        
        mapTypeLocations.forEach { category, locations in
            if let index = locations.firstIndex(where: {$0.locationCore === locationUpdate.locationCore}) {
                locationOld = locations[index]
            }
        }
        
        if let location = locationOld {
            removeLocation(with: location)
            addLocation(with: locationUpdate)
        }
    }
        
    public func removeLocation(with location: LocationMeta) {
        if var locations = mapTypeLocations[location.category], let index = locations.firstIndex(where: {$0.id == location.id}){
            
            if let locationCore = locations[index].locationCore {
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
