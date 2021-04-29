//
//  MapViewController.swift
//  MyLocations
//
//  Created by Hui Chih Wang on 2021/4/29.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    private let minDisplayDegree: CLLocationDegrees = 0.005
    private let scaleFactor: Double = 1.3
    private let annotationId = "Location"
    private let showLocationInfoSegueId = "ShowLocationFromMap"
    
    private var locations: Locations? {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        return appDelegate?.locations
    }
    
    private var annotationsOnScreen = [MKAnnotation]() {
        willSet {
            mapView.removeAnnotations(annotationsOnScreen)
        }
        
        didSet {
            mapView.addAnnotations(annotationsOnScreen)
        }
    }
    
    private var displayRegionCenterAtUser: MKCoordinateRegion {
        let displayDiameter: CLLocationDistance = 500
        let region = MKCoordinateRegion(center: mapView.userLocation.coordinate, latitudinalMeters: displayDiameter, longitudinalMeters: displayDiameter)
        
        return mapView.regionThatFits(region)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadLocations()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadLocations()
    }
    
    private func reloadLocations() {
        annotationsOnScreen = locations?.allLocations ?? [MKAnnotation]()
        showLocations()
    }
    
    
     // MARK: - Navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showLocationInfoSegueId, let controller = segue.destination as? TagViewController {
            controller.locationInfo = sender as! LocationMeta
        }
     }
     
    @IBAction func showUsers() {
        mapView.setRegion(displayRegionCenterAtUser, animated: true)
    }
    
    @IBAction func showLocations() {
        let region = getDisplayRegion(with: annotationsOnScreen)
        mapView.setRegion(region, animated: true)
    }
    
    private func getDisplayRegion(with annotations: [MKAnnotation]) -> MKCoordinateRegion {
        if annotations.isEmpty {
            return displayRegionCenterAtUser
        }
        
        var xMin = Double.infinity
        var yMin = Double.infinity
        var xMax = -Double.infinity
        var yMax = -Double.infinity
        
        annotations.forEach { annotation in
            let coordinate = annotation.coordinate
            
            if coordinate.latitude < xMin {
                xMin = coordinate.latitude
            }
            if coordinate.latitude > xMax {
                xMax = coordinate.latitude
            }
            
            if coordinate.longitude < yMin {
                yMin = coordinate.longitude
            }
            if coordinate.longitude > yMax {
                yMax = coordinate.longitude
            }
        }
        
        let center = CLLocationCoordinate2D(latitude: (xMin + xMax) / 2, longitude: (yMin + yMax) / 2)
        let width = max((xMax - xMin) * scaleFactor, minDisplayDegree)
        let height = max((yMax - yMin) * scaleFactor, minDisplayDegree)
        
        
        let span = MKCoordinateSpan(latitudeDelta: width, longitudeDelta: height)
        let region = MKCoordinateRegion(center: center, span: span)
        
        return mapView.regionThatFits(region)
    }
    
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is LocationMeta else {
            return nil
        }
        
        var annotationView: MKPinImageAnnotationView?
        
        if let reusableView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationId) {
            reusableView.annotation = annotation
            annotationView = reusableView as? MKPinImageAnnotationView
        }
        else {
            annotationView = MKPinImageAnnotationView(annotation: annotation, reuseIdentifier: annotationId)
        }
        
        annotationView?.configure(with: annotation as! LocationMeta)
        annotationView?.configureButtonAction(with: createButtonAction(with: annotation))
        
        return annotationView
    }
    
    private func createButtonAction(with location: MKAnnotation) -> UIAction {
        UIAction { _ in
            self.performSegue(withIdentifier: self.showLocationInfoSegueId, sender: location)
        }
    }
}
