//
//  ReferencePoint.swift
//  MapView01
//
//  Created by Mark Thorogood on 4/26/17.
//  Copyright © 2017 Perkins Coie. All rights reserved.
//

import Foundation
import MapKit

class ReferencePoint: NSObject, MKAnnotation, NSCoding {
    static let titleKey = "Title"
    static let subtitleKey = "Subtitle"
    static let latitudeKey = "Latitude"
    static let longitudeKey = "Longitude"
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(latitude: Double, longitude: Double, title: String?, subtitle: String?) {
        coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        self.title = title
        self.subtitle = subtitle
    }
    
    required init?(coder: NSCoder) {
        // To rehydrate the object.
        title = coder.decodeObject(forKey: ReferencePoint.titleKey) as! String?
        subtitle = coder.decodeObject(forKey: ReferencePoint.subtitleKey) as! String?
        let latitude = coder.decodeDouble(forKey: ReferencePoint.latitudeKey)
        let longitude = coder.decodeDouble(forKey: ReferencePoint.longitudeKey)
        coordinate = CLLocationCoordinate2D.init(latitude: latitude, longitude: longitude)
        
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(title, forKey: ReferencePoint.titleKey)
        aCoder.encode(subtitle, forKey: ReferencePoint.subtitleKey)
        aCoder.encode(coordinate.latitude, forKey: ReferencePoint.latitudeKey)
        aCoder.encode(coordinate.longitude, forKey: ReferencePoint.longitudeKey)
    }

}
