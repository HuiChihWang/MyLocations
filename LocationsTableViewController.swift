//
//  LocationsTableViewController.swift
//  MyLocations
//
//  Created by Hui Chih Wang on 2021/4/26.
//

import UIKit

class LocationsTableViewController: UITableViewController {

    private let locationCellId = "LocationCell"
    private let locations = Locations()
        
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        locations.addLocation(with: LocationMeta(description: "None-A", category: .none))
        locations.addLocation(with: LocationMeta(description: "None-B", category: .none))
        locations.addLocation(with: LocationMeta(description: "Bar-A", category: .bar))
        locations.addLocation(with: LocationMeta(description: "Bar-B", category: .bar))
        locations.addLocation(with: LocationMeta(description: "Bar-C", category: .bar))
        locations.addLocation(with: LocationMeta(description: "Club-A", category: .club))
        locations.addLocation(with: LocationMeta(description: "Coffee-A", category: .coffee))
        
        tableView.reloadData()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: locationCellId, for: indexPath)

        
        if let category = locations.getCategory(by: indexPath.section), let location = locations.getLocation(in: category, with: indexPath.row) {
            cell.textLabel?.text = location.description
            cell.detailTextLabel?.text = location.address
        }
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
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
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
