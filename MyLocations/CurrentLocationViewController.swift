//
//  ViewController.swift
//  MyLocations
//
//  Created by Hui Chih Wang on 2021/4/19.
//

import UIKit

class CurrentLocationViewController: UIViewController {

    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    let locationHelper = LocationHandler()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func updateLocation(_ sender: Any) {
        let location = locationHelper.getCurrentLocation()
        latitudeLabel.text = String(format: "%.8f", location.coordinate.latitude)
        longitudeLabel.text = String(format: "%.8f", location.coordinate.longitude)
    }
    
}

