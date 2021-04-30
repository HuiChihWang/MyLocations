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
    
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var photoHeight: NSLayoutConstraint!
    
    var locationInfo = LocationMeta(location: CLLocation(), placemark: nil)
    
    private var image: UIImage? {
        didSet {
            photoView.image = image
            photoHeight.constant = image == nil ? 24 : 100
            tableView.reloadData()
        }
    }
    
    
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
    
    
    private var isEditLocation: Bool {
        locationInfo.isInCoreData
    }
    
    private var locations: Locations {
        let appDelegate =  UIApplication.shared.delegate as! AppDelegate
        return appDelegate.locations
    }
    
    private let pickCategorySegueId = "PickCategory"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
        configureInfo(with: locationInfo)
    }
    
    
    private func configureInfo(with locationInfo: LocationMeta) {
        latitudeLabel.text = String(format: "%.8f", locationInfo.location.coordinate.latitude)
        longitudeLabel.text = String(format: "%.8f", locationInfo.location.coordinate.longitude)
        addressLabel.text = locationInfo.address
        dateLabel.text = dateFormatter.string(from: locationInfo.date)
        categoryLabel.text = locationInfo.category.rawValue
        descriptionText.text = locationInfo.localDescription
        
        if let url = locationInfo.photoURL {
            image = UIImage(contentsOfFile: url.path)
        }
    }
    
    @IBAction func done(_ sender: Any) {
        locationInfo.category = Category(rawValue: categoryLabel.text!) ?? .none
        locationInfo.localDescription = descriptionText.text
        locationInfo.imageData = image?.jpegData(compressionQuality: 0.7)
        
        if isEditLocation {
            locations.updateLocation(with: locationInfo)
        }
        else {
            locations.addLocation(with: locationInfo)
        }
        
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
            showPhotoMenu()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    

}

extension TagViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.editedImage] as? UIImage {
            self.image = image
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    private func showPhotoMenu() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let photoAction = UIAlertAction(title: "Choose From Library", style: .default) { _ in
            self.pickPhotoFromLibrary()
            print("choose Photo")
        }
        
        alert.addAction(photoAction)
        
        let cameraAction = UIAlertAction(title: "Take Photo", style: .default) { _ in
            self.takePhotoFromCamera()
            print("Take photo")
        }
        alert.addAction(cameraAction)
        
        
        if image != nil {
            let actionRemove = UIAlertAction(title: "Remove Photo", style: .destructive) { _ in
                self.image = nil
            }
            alert.addAction(actionRemove)
        }
        
        let cancleAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancleAction)
        

        
        present(alert, animated: true, completion: nil)
    }
    
    private func checkCameraAvailable() -> Bool {
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            let alert = UIAlertController(title: nil, message: "Camera service is not available on this device", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
        
        return UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    private func takePhotoFromCamera() {
        if checkCameraAvailable() {
            imagePickerController.sourceType = .camera
            present(imagePickerController, animated: true, completion: nil)
        }
    }
    
    private func pickPhotoFromLibrary() {
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
}
