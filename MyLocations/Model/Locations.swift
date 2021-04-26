//
//  Locations.swift
//  MyLocations
//
//  Created by Hui Chih Wang on 2021/4/26.
//

import Foundation
import CoreLocation

struct LocationMeta: Identifiable {
    var location: CLLocation = CLLocation()
    var placemark: CLPlacemark?
    let date = Date()
    
    var description = ""
    var photoUrl: String?
    var category = Category.none
        
    var address: String {
        placemark?.formattedAddress ?? "Unknown"
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
}


class Locations {
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
        
        mapTypeLocations[location.category]?.append(location)
    }
    
    public func removeLocation(with location: LocationMeta) {
        if var locations = mapTypeLocations[location.category], let index = locations.firstIndex(where: {$0.id == location.id}) {
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
