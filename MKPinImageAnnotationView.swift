//
//  MKPinImageAnnotationView.swift
//  MyLocations
//
//  Created by Hui Chih Wang on 2021/4/29.
//

import UIKit
import MapKit

class MKPinImageAnnotationView: MKPinAnnotationView {
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
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

        
        rightCalloutAccessoryView = configureButton()
        
        if let url = location.photoURL {
            leftCalloutAccessoryView = configureImage(with: url)
        }
    }
    
    private func configureButton() -> UIButton {
        let button = UIButton(type: .detailDisclosure)
        return button
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
