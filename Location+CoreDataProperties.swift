//
//  Location+CoreDataProperties.swift
//  MyLocations
//
//  Created by Hui Chih Wang on 2021/4/26.
//
//

import Foundation
import CoreData
import CoreLocation

extension Location {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Location> {
        return NSFetchRequest<Location>(entityName: "Location")
    }

    @NSManaged public var category: String?
    @NSManaged public var date: Date?
    @NSManaged public var latitude: Double
    @NSManaged public var localDescription: String?
    @NSManaged public var longitude: Double
    @NSManaged public var placemark: CLPlacemark?

}

extension Location : Identifiable {

}
