//
//  MapVesselAnnotation.swift
//  Ferries
//
//  Created by Mark Thorogood on 6/7/17.
//  Copyright © 2017 Perkins Coie. All rights reserved.
//

import UIKit
import CoreData
import MapKit

class MapVesselAnnotation: NSObject, MKAnnotation {
    
    var image: UIImage?
    
    dynamic var title: String? = nil
    dynamic var subtitle: String? = nil
    dynamic var coordinate: CLLocationCoordinate2D

    
    init(latitude: Double, longitude: Double, title: String?, subtitle: String?) {
        coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        self.title = title
        self.subtitle = subtitle
    }
    
    class func annotation(vessel: Vessel) -> MapVesselAnnotation {
        let lastPositionUpdateTime = Utilities.dateAsFormattedString(date: vessel.lastPositionUpdateTime)
        
        return MapVesselAnnotation(latitude: vessel.lastLatitude, longitude: vessel.lastLongitude, title: vessel.name, subtitle: "\(String(describing: lastPositionUpdateTime ))")
        
//        
//        return MapVesselAnnotation(latitude: vessel.lastLatitude, longitude: vessel.lastLongitude, title: vessel.name, subtitle: Utilities.dateAsFormattedString(date: vessel.lastPositionUpdateTime))
    }
    
    func update(vessel: Vessel) {
        coordinate = CLLocationCoordinate2D(latitude: vessel.lastLatitude, longitude: vessel.lastLongitude)
        self.title = vessel.name
    }
    
}
