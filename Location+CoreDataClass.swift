//
//  Location+CoreDataClass.swift
//  MyLocations
//
//  Created by Hui Chih Wang on 2021/4/26.
//
//

import Foundation
import CoreData
import CoreLocation

@objc(Location)
public class Location: NSManagedObject {

    func toLocationMeta() -> LocationMeta {
        let location = CLLocation(latitude: self.latitude, longitude: self.longitude)
        
        var locationMeta = LocationMeta(location: location, placemark: self.placemark)
        
        locationMeta.description = self.localDescription ?? ""
        locationMeta.category = Category(rawValue: self.category ?? "") ?? .none
        locationMeta.date = self.date ?? Date()
        locationMeta.locationCore = self
        locationMeta.photoURL = photoURL
        
        return locationMeta
    }
}
