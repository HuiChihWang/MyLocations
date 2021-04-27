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
import UIKit

@objc(Location)
public class Location: NSManagedObject {
    
    func toLocationMeta() -> LocationMeta {
        let location = CLLocation(latitude: self.latitude, longitude: self.longitude)
        
        var locationMeta = LocationMeta(location: location, placemark: self.placemark)
        
        locationMeta.description = self.localDescription ?? ""
        locationMeta.category = Category(rawValue: self.category ?? "") ?? .none
        
        locationMeta.locationCore = self
        
        if let date = date {
            locationMeta.date = date
        }
        
        if let id = id {
            locationMeta.id = id
        }
        
        return locationMeta
    }
    
    func saveImage(with data: Data) {
        if let url = photoURL {
            do {
                try data.write(to: url)
                print("save image to URL: \(url)")
            } catch {
                print("Error in saving image: \(error)")
            }
        }
    }
    
    func deleteImage() {
        if let url = photoURL {
            do {
                try FileManager.default.removeItem(at: url)
            } catch {
                print("Error in removing image at \(url)")
            }
        }
    }
    
}
