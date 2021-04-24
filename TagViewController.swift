//
//  TagViewController.swift
//  MyLocations
//
//  Created by Hui Chih Wang on 2021/4/24.
//

import UIKit
import CoreLocation

class TagViewController: UITableViewController {

    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
    
    var locationInfo = LocationMeta(location: CLLocation(), address: "")
    
    private let pickCategorySegueId = "PickCategory"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        configureInfo(with: locationInfo)
    }
    
    
    private func configureInfo(with locationInfo: LocationMeta) {
        latitudeLabel.text = String(format: "%.8f", locationInfo.location.coordinate.latitude)
        longitudeLabel.text = String(format: "%.8f", locationInfo.location.coordinate.longitude)
        addressLabel.text = locationInfo.address
        dateLabel.text = dateFormatter.string(from: locationInfo.date)
    }
    
    @IBAction func done(_ sender: Any) {
    }
    
    @IBAction func cancel(_ sender: Any) {
    }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == pickCategorySegueId, let controller = segue.destination as? CategoryPickerTableViewController {
            controller.seletedCategory = Category(rawValue: categoryLabel.text!) ?? .none
        }
    }
    @IBAction func unwindToTagView(_ unwindSegue: UIStoryboardSegue) {
        if let controller = unwindSegue.source as? CategoryPickerTableViewController {
            print("unwind from category view to tag view")
            categoryLabel.text = controller.seletedCategory.rawValue
        }
    }
    
        override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
            return indexPath.section != 3 ? indexPath : nil
        }

    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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
    

}