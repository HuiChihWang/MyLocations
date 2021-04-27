//
//  LocationMeta.swift
//  MyLocations
//
//  Created by Hui Chih Wang on 2021/4/28.
//

import Foundation
import CoreLocation
import CoreData

class LocationMeta: Identifiable {
    let location: CLLocation
    let placemark: CLPlacemark?
    var date = Date()
    var id = UUID()
    
    var description = ""
  
    var category = Category.none
        
    var locationCore: Location?
    
    var imageData: Data?

    
    var photoURL: URL? {
        let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let filename = "Photo-\(id).jpg"
        return documentPath.appendingPathComponent(filename)
    }
    
        
    var address: String {
        placemark?.formattedAddress ?? "Unknown"
    }
    
    var isInCoreData: Bool {
        return locationCore != nil
    }
    
    
    init(location: CLLocation, placemark: CLPlacemark?) {
        self.location = location
        self.placemark = placemark
    }
        
    func toLocation(context: NSManagedObjectContext) -> Location {
        let location = Location(context: context)
        location.category = category.rawValue
        location.latitude = self.location.coordinate.latitude
        location.longitude = self.location.coordinate.longitude
        location.localDescription = description
        location.placemark = placemark
        location.date = date
        location.photoURL = photoURL
        location.id = id
        
        return location
    }
}
