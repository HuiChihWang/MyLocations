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
    
    private var locations: Locations? {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        return appDelegate?.locations
    }
    
    private var locationsOnScreen = [LocationMeta]() {
        willSet {
            mapView.removeAnnotations(locationsOnScreen)
        }
        
        didSet {
            mapView.addAnnotations(locationsOnScreen)
        }
    }
    
    private var displayRegion: MKCoordinateRegion {
        let region = MKCoordinateRegion(center: mapView.userLocation.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        return mapView.regionThatFits(region)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        reloadLocations()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadLocations()
    }
    
    private func reloadLocations() {
        locationsOnScreen = locations?.allLocations ?? [LocationMeta]()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func showUsers(_ sender: Any) {
        mapView.setRegion(displayRegion, animated: true)
    }
    
    
    @IBAction func showLocations(_ sender: Any) {
    }
    
}

extension MapViewController: MKMapViewDelegate {
    
}
