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
    @IBOutlet weak var descriptionText: UITextView!
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
    
    private lazy var imagePickerController: UIImagePickerController = {
       let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        picker.delegate = self
        return picker
    }()
        
    var locationInfo = LocationMeta(location: CLLocation(), placemark: nil)
    
    private var locations: Locations {
        let appDelegate =  UIApplication.shared.delegate as! AppDelegate
        return appDelegate.locations
    }
    
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
        categoryLabel.text = locationInfo.category.rawValue
        descriptionText.text = locationInfo.description
    }
    
    // TODO: Test here
    @IBAction func done(_ sender: Any) {
        locationInfo.category = Category(rawValue: categoryLabel.text!) ?? .none
        locationInfo.description = descriptionText.text
        
        if locationInfo.isInCoreData {
            locations.updateLocation(with: locationInfo)
        }
        else {
            locations.addLocation(with: locationInfo)
        }
        
//        let appDelegate = UIApplication.shared.delegate as? AppDelegate
//
//        if let container = appDelegate?.persistentContainer {
//            let location = Location(context: container.viewContext)
//            location.category = locationInfo.category.rawValue
//            location.localDescription = locationInfo.description
//            location.latitude = locationInfo.location.coordinate.latitude
//            location.longitude = locationInfo.location.coordinate.longitude
//            location.placemark = locationInfo.placemark
//            location.date = locationInfo.date
//        }
        
//        appDelegate?.saveContext()
//        print("Save context: \(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0])")
        
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cancel(_ sender: Any) {
        navigationController?.popViewController(animated: true)
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath == IndexPath(row: 0, section: 2) {
            present(imagePickerController, animated: true, completion: nil)
        }
    }
}

extension TagViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true, completion: nil)
    }
}
