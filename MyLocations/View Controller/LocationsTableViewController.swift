//
//  LocationsTableViewController.swift
//  MyLocations
//
//  Created by Hui Chih Wang on 2021/4/26.
//

import UIKit

class LocationsTableViewController: UITableViewController {
    
    private let locationCellId = "LocationCell"
    private let editSegueId = "EditLocation"
    
    private var locations: Locations {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.locations
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        tableView.reloadData()
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == editSegueId {
            if let controller = segue.destination as? TagViewController, let location = sender as? LocationMeta {
                controller.locationInfo = location
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return locations.numberOfType
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return locations.getCategory(by: section)?.rawValue
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if let category = locations.getCategory(by: section) {
            return locations.getLocationsCountByCategory(with: category)
        }
        return 0
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: locationCellId, for: indexPath) as?  LocationTableViewCell
        
        if let category = locations.getCategory(by: indexPath.section), let location = locations.getLocation(in: category, with: indexPath.row) {
            cell?.configure(with: location)
        }
        
        return cell ?? UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let category = locations.getCategory(by: indexPath.section), let location = locations.getLocation(in: category, with: indexPath.row) {
            performSegue(withIdentifier: editSegueId, sender: location)
        }
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            //             Delete the row from the data source
            if let category = locations.getCategory(by: indexPath.section), let location = locations.getLocation(in: category, with: indexPath.row) {
                locations.removeLocation(with: location)
            }
            tableView.reloadData()
            //            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
}
