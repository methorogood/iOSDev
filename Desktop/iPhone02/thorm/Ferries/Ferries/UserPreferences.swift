//
//  UserPreferences.swift
//  Ferries
//
//  Created by Mark Thorogood on 6/7/17.
//  Copyright © 2017 Perkins Coie. All rights reserved.
//

//
//  UserPreferences.swift
//  HW02
//
//  Created by Mark Thorogood on 4/28/17.
//  Copyright © 2017 Perkins Coie. All rights reserved.
//

import UIKit

class UserPreferences: NSObject {
    
    static let LATITUDE_CENTER_KEY = "latitudeCenterKey"
    static let LONGITUDE_CENTER_KEY = "longitudeCenterKey"
    static let LATITUDE_DELTA_KEY = "latitudeDeltaKey"
    static let LONGITUDE_DELTA_KEY = "longitudeDeltaKey"
    
    let defaults = UserDefaults.standard
    
    var latitudeCenter: Double {
        set {
            defaults.set(newValue, forKey: UserPreferences.LATITUDE_CENTER_KEY)
        }
        get {
            if (defaults.value(forKey: UserPreferences.LATITUDE_CENTER_KEY) == nil) {
                return 47.622
            } else {
                return defaults.double(forKey: UserPreferences.LATITUDE_CENTER_KEY)
            }
        }
    }
    
    var latitudeDelta: Double {
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
    
    var longitudeCenter: Double {
        set {
            defaults.set(newValue, forKey: UserPreferences.LONGITUDE_CENTER_KEY)
        }
        get {
            if (defaults.value(forKeyPath: UserPreferences.LONGITUDE_CENTER_KEY) == nil) {
                return -122.3492
            } else {
                return defaults.double(forKey: UserPreferences.LONGITUDE_CENTER_KEY)
            }
        }
    }
    
    var longitudeDelta: Double {
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
    
}
