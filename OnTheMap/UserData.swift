//
//  UserData.swift
//  OnTheMap
//
//  Created by Janaki Burugula on Dec/24/2015.
//  Copyright © 2015 janaki. All rights reserved.
//

import UIKit
import MapKit

class UserData: NSObject {
    
    // Data for posting user location
    var userFirstName: String!
    var userLastName: String!
    var mapString: String!
    var mediaURL: String!
    var region: MKCoordinateRegion!
    
    
    // Data for updating user location
    var objectID: String!
    
    // Student locations array
    var locations: [StudentLocations]!
    
    
    // MARK: - Shared Instance
    
    class func sharedInstance() -> UserData {
        
        struct Singleton {
            static var sharedInstance = UserData()
        }
        
        return Singleton.sharedInstance
    }
}
