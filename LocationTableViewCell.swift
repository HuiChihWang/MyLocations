//
//  LocationTableViewCell.swift
//  MyLocations
//
//  Created by Hui Chih Wang on 2021/4/28.
//

import UIKit

class LocationTableViewCell: UITableViewCell {
    @IBOutlet weak var thumbnailImage: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    private let defaultImage = UIImage(named: "DefaultLocation")?.withRenderingMode(.alwaysTemplate)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with location: LocationMeta) {
        thumbnailImage.layer.borderColor = UIColor(named: "Image Border Color")?.cgColor
        thumbnailImage.layer.borderWidth = 1
        thumbnailImage.layer.cornerRadius = 5

        descriptionLabel.text = location.description
        addressLabel.text = location.address
        
        if let imagePath = location.photoURL {
            thumbnailImage.image = UIImage(contentsOfFile: imagePath.path) ?? defaultImage
        }
    }

}
