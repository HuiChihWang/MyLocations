//
//  LocationHandler.swift
//  MyLocations
//
//  Created by Hui Chih Wang on 2021/4/19.
//

import Foundation
import CoreLocation
import Contacts

struct LocationMeta {
    let location: CLLocation
    let placemark: CLPlacemark?
    let date = Date()
    
    var description = ""
    var photoUrl: String?
    var category = Category.none
        
    var address: String {
        placemark?.formattedAddress ?? "Unknown"
    }
        
}


class LocationHandler: NSObject {
    
    lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        return locationManager
    }()
    
    lazy var geoCoder = CLGeocoder()
    
    var currentLocation: CLLocation?
    var address: String?
    var placemark: CLPlacemark?
    
    private var isAddressUpdated = false
    
    var status: LocationStatus = .initial
    
    public func initializeSearch() {
        requestAuthorization()
        status = .searching
    }
    
    public func searchLocation() {
        guard status == .searching else {
            return
        }
        
        locationManager.startUpdatingLocation()
        updateLocation()
        locationManager.stopUpdatingLocation()
        
        if let location = currentLocation {
            transformLocationToAddress(with: location)
            while !isAddressUpdated { }
        }
    }
    
    private func updateLocation() {
        while status == .searching {
            if let newLocation = locationManager.location {
                
                if newLocation.timestamp.timeIntervalSinceNow < -5 {
                    continue
                }
                
                if newLocation.horizontalAccuracy < 0 {
                    continue
                }
                
                if newLocation.horizontalAccuracy < locationManager.desiredAccuracy {
                    print("Updated")
                    currentLocation = newLocation
                    status = .updated
                }
            }
        }
    }
    
    private func requestAuthorization() {
        if locationManager.authorizationStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    private func transformLocationToAddress(with location: CLLocation) {
        isAddressUpdated = false
        geoCoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            self?.placemark = placemarks?.last
            self?.address = self?.placemark?.formattedAddress
            self?.isAddressUpdated = true
        }
        
    }
}

extension LocationHandler: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("didFailWithError \(error.localizedDescription)")
        
        if (locationManager.authorizationStatus == .notDetermined) {
            return
        }
        switch (error as NSError).code {
        case CLError.locationUnknown.rawValue:
            status = .unknown
        case CLError.denied.rawValue:
            status = .disabled
        case CLError.network.rawValue:
            status = .networkIssue
        default:
            status = .initial
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("did update locations \(String(describing: locations.last))")
    }
}

extension CLPlacemark {
    var formattedAddress: String {
        guard postalAddress != nil else {
            return "UnknownPlace"
        }
        
        let formatter = CNPostalAddressFormatter()
        var address = formatter.string(from: postalAddress!)
        address = address.replacingOccurrences(of: "\n", with: ", ")
        return address
    }
}
enum LocationStatus: String {
    case searching = "Searching..."
    case disabled = "Location Services Disabled"
    case updated = "Current Location"
    case unknown = "Error Getting Location"
    case networkIssue = "Please Turn on Mobile Network"
    case initial = "Tap 'Get My Location' to Start"
}

enum Category: String, CaseIterable {
    case none = "No Category"
    case bar = "Bar"
    case club = "Club"
    case grocery = "Grocery Store"
    case history = "Historical Building"
    case house = "House"
    case landmark = "Land Mark"
    case coffee = "Cafe"
}


