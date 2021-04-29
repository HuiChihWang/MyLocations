//
//  MKPinImageAnnotationView.swift
//  MyLocations
//
//  Created by Hui Chih Wang on 2021/4/29.
//

import UIKit
import MapKit

class MKPinImageAnnotationView: MKPinAnnotationView {

    private static let defaultImage = UIImage(named: "DefaultLocation")?.withRenderingMode(.alwaysTemplate)
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        canShowCallout = true
        isEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configure(with location: LocationMeta) {
        canShowCallout = true
        isEnabled = true

        rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        
        if let url = location.photoURL {
            leftCalloutAccessoryView = configureImage(with: url)
        }
    }
    
    func configureButtonAction(with action: UIAction) {
        if let button = rightCalloutAccessoryView as? UIButton {
            button.addAction(action, for: .touchUpInside)
        }
    }
    
    private func configureImage(with imageUrl: URL) -> UIImageView {
        let image = UIImage(contentsOfFile: imageUrl.path) ?? MKPinImageAnnotationView.defaultImage
        
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        imageView.layer.cornerRadius = 5
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
    }
}
