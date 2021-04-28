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
    
    func getImageURL() -> URL? {
        let documentDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return documentDir.appendingPathComponent("Photo-\(id).jpg")
    }
    
    func toLocationMeta() -> LocationMeta {
        let location = CLLocation(latitude: self.latitude, longitude: self.longitude)
        
        let locationMeta = LocationMeta(location: location, placemark: self.placemark as? CLPlacemark)
        
        locationMeta.description = self.localDescription ?? ""
        locationMeta.category = Category(rawValue: self.category ?? "") ?? .none
        
        locationMeta.locationCore = self
        
        locationMeta.date = date ?? Date()
        
        locationMeta.id = id
        locationMeta.locationCore = self
        
        return locationMeta
    }
    
    func saveImage(with data: Data) {
        if let url = getImageURL() {
            do {
                try data.write(to: url)
                print("save image to URL: \(url)")
            } catch {
                print("Error in saving image: \(error)")
            }
        }
    }
    
    func deleteImage() {
        if let url = getImageURL() {
            do {
                try FileManager.default.removeItem(at: url)
            } catch {
                print("Error in removing image at \(url)")
            }
        }
    }
    
}
