//
//  LocationMeta.swift
//  MyLocations
//
//  Created by Hui Chih Wang on 2021/4/28.
//

import Foundation
import CoreLocation
import CoreData
import MapKit

class LocationMeta: NSObject, Identifiable {
    let location: CLLocation
    let placemark: CLPlacemark?
    var date = Date()
    var id = UUID()
    
    var localDescription = "" {
        didSet {
            locationCore?.localDescription = localDescription
        }
    }
  
    var category = Category.none {
        didSet {
            locationCore?.category = category.rawValue
        }
    }
        
    var locationCore: Location?
    
    var imageData: Data? {
        didSet {
            if let data = imageData {
                locationCore?.saveImage(with: data)
            }
            else {
                locationCore?.deleteImage()
            }
        }
    }

    
    var photoURL: URL? {
        return locationCore?.getImageURL()
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
        
    func toLocation(context: NSManagedObjectContext) {
        let location = Location(context: context)
        location.category = category.rawValue
        location.latitude = self.location.coordinate.latitude
        location.longitude = self.location.coordinate.longitude
        location.localDescription = localDescription
        location.placemark = placemark
        location.date = date
        location.id = id
        
        locationCore = location
        
        if let data = imageData {
            locationCore?.saveImage(with: data)
        }
    }
}

extension LocationMeta: MKAnnotation {
    var coordinate: CLLocationCoordinate2D {
        location.coordinate
    }
    
    var title: String? {
        localDescription.isEmpty ? "No Description" : localDescription
    }
    
    var subtitle: String? {
        category.rawValue
    }
}
