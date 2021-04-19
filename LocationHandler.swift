//
//  LocationHandler.swift
//  MyLocations
//
//  Created by Hui Chih Wang on 2021/4/19.
//

import Foundation
import CoreLocation

class LocationHandler {
    let locationManager = CLLocationManager()
    
    init() {
        setupLocationManager()
    }
    
    public func getCurrentLocation() -> CLLocation {
        locationManager.startUpdatingLocation()
        return locationManager.location ?? CLLocation()
    }
    
    private func setupLocationManager() {
//        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
    }
}

//extension LocationHandler: CLLocationManagerDelegate {
//}


