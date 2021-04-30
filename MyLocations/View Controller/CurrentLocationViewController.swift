//
//  ViewController.swift
//  MyLocations
//
//  Created by Hui Chih Wang on 2021/4/19.
//

import UIKit
import CoreLocation

class CurrentLocationViewController: UIViewController {
    
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var searchButton: UIImageView!
    @IBOutlet weak var indicator: UIActivityIndicatorView! {
        didSet {
            indicator.isHidden = true
        }
    }
    @IBOutlet weak var saveButton: UIButton! {
        didSet {
            saveButton.layer.cornerRadius = 10
        }
    }
    @IBOutlet weak var cancelButton: UIButton! {
        didSet {
            cancelButton.layer.cornerRadius = 10
        }
    }
    
    private let locationHelper = LocationHandler()
    private let tagViewSegueId = "TagCurrentLocation"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == tagViewSegueId, let controller = segue.destination as? TagViewController {
            if let location = locationHelper.currentLocation {
                let locationInfo = LocationMeta(location: location, placemark: locationHelper.placemark)
                controller.locationInfo = locationInfo
            }
        }
    }
    
    @IBAction func cancle(_ sender: Any) {
        locationHelper.clearSearchResult()
        updateView()
    }
    
    
    @IBAction func updateLocation(_ sender: Any) {
        locationHelper.initializeSearch()
        updateView()
        
        DispatchQueue.global().async {
            
            self.locationHelper.searchLocation()
            
            DispatchQueue.main.async {
                self.updateView()
            }
        }
    }
    
    private func updateView() {
        configureLocationView(with: locationHelper.currentLocation ?? CLLocation(), at: locationHelper.address ?? "Unknow Address")
        updateMessageStatus(with: locationHelper.status)
    }
    private func configureLocationView(with location: CLLocation, at address: String) {
        latitudeLabel.text = String(format: "%.8f", location.coordinate.latitude)
        longitudeLabel.text = String(format: "%.8f", location.coordinate.longitude)
        addressLabel.text = address
    }
    
    private func updateMessageStatus(with status: LocationStatus) {
        messageLabel.text = status.rawValue
        searchButton.isUserInteractionEnabled = status != .searching
        indicator.isHidden = status != .searching
        locationView.isHidden = status != .updated
        
        if searchButton.isHidden {
            indicator.stopAnimating()
        }
        else {
            indicator.startAnimating()
        }
        
        if (status == .disabled) {
            showDisabledAlert()
        }
    }
    
    private func showDisabledAlert() {
        let alert = UIAlertController(title: "Location Service Disabled", message: "Please enable location services for this app in Settings.", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
}

