//
//  UserPreferences.swift
//  HW02
//
//  Created by Mark Thorogood on 4/28/17.
//  Copyright © 2017 Perkins Coie. All rights reserved.
//

import UIKit

class UserPreferences: NSObject {
    
    static let TRAFFIC_KEY = "trafficKey"
    static let MY_LOCATION_KEY = "myLocationKey"
    static let POINT_OF_INTEREST_KEY = "pointOfInterestKey"
    static let LATITUDE_KEY = "latitudeKey"
    static let LONGITUDE_KEY = "longitudeKey"
    static let LATITUDE_DELTA_KEY = "latitudeDeltaKey"
    static let LONGITUDE_DELTA_KEY = "longitudeDeltaKey"
    static let MAP_TYPE_KEY = "mapTypeKey"
    
    let defaults = UserDefaults.standard
    
    var latitudeSetting: Double {
        set {
            defaults.set(newValue, forKey: UserPreferences.LATITUDE_KEY)
        }
        get {
            if (defaults.value(forKey: UserPreferences.LATITUDE_KEY) == nil) {
                return 47.816
            } else {
                return defaults.double(forKey: UserPreferences.LATITUDE_KEY)
            }
        }
    }
    
    var latitudeDeltaSetting: Double {
        set {
            defaults.set(newValue, forKey: UserPreferences.LATITUDE_DELTA_KEY)
        }
        get {
            if (defaults.value(forKey: UserPreferences.LATITUDE_DELTA_KEY) == nil) {
                return 0.01
            } else {
                return defaults.double(forKey: UserPreferences.LATITUDE_DELTA_KEY)
            }
        }
    }
    
    var longitudeSetting: Double {
        set {
            defaults.set(newValue, forKey: UserPreferences.LONGITUDE_KEY)
        }
        get {
            if (defaults.value(forKeyPath: UserPreferences.LONGITUDE_KEY) == nil) {
                return -122.128
            } else {
                return defaults.double(forKey: UserPreferences.LONGITUDE_KEY)
            }
        }
    }
    
    var longitudeDeltaSetting: Double {
        set {
            defaults.set(newValue, forKey: UserPreferences.LONGITUDE_DELTA_KEY)
        }
        get {
            if (defaults.value(forKeyPath: UserPreferences.LONGITUDE_DELTA_KEY) == nil) {
                return 0.01
            } else {
                return defaults.double(forKey: UserPreferences.LONGITUDE_DELTA_KEY)
            }
        }
    }
    
    var mapTypeSetting: Int {
        set {
            defaults.set(newValue, forKey: UserPreferences.MAP_TYPE_KEY)
        }
        get {
            return defaults.integer(forKey: UserPreferences.MAP_TYPE_KEY)
        }
    }
    
    var myLocationSetting: Bool {
        set {
            defaults.set(newValue, forKey: UserPreferences.MY_LOCATION_KEY)
        }
        get {
            return defaults.bool(forKey: UserPreferences.MY_LOCATION_KEY)
        }
    }
    
    var pointsOfInterestSetting: Bool {
        set {
            defaults.set(newValue, forKey: UserPreferences.POINT_OF_INTEREST_KEY)
        }
        get {
            return defaults.bool(forKey: UserPreferences.POINT_OF_INTEREST_KEY)
        }
    }
    
    var trafficSetting: Bool {
        set {
            defaults.set(newValue, forKey: UserPreferences.TRAFFIC_KEY)
        }
        get {
            return defaults.bool(forKey: UserPreferences.TRAFFIC_KEY)
        }
    }
    
}
