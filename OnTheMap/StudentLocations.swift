//
//  StudentLocations.swift
//  OnTheMap
//
//  Created by Janaki Burugula on Dec/20/2015.
//  Copyright © 2015 janaki. All rights reserved.
//

import Foundation
import Foundation
import MapKit

struct StudentLocations {
    
    static var sharedInstance = StudentLocations()
    
    
    var createdAt = ""
    var firstName = ""
    var lastName = ""
    var latitude = 0.0
    var longitude = 0.0
    var mapString = ""
    var mediaURL = ""
    var objectID = ""
    var uniqueKey = ""
    var updatedAt = ""
    
    // Construct a StudentLocation from a dictionary
    init() {}
    
    //Construct a StudentLocation from a dictionary
    init(dictionary: [String : AnyObject]) {
        
        createdAt = dictionary[OTMClient.JSONResponseKeys.CreatedAt] as! String
        firstName = dictionary[OTMClient.JSONResponseKeys.FirstName] as! String
        lastName = dictionary[OTMClient.JSONResponseKeys.LastName] as! String
        latitude = dictionary[OTMClient.JSONResponseKeys.Latitude] as! Double
        longitude = dictionary[OTMClient.JSONResponseKeys.Longitude] as! Double
        mapString = dictionary[OTMClient.JSONResponseKeys.MapString] as! String
        mediaURL = dictionary[OTMClient.JSONResponseKeys.MediaURL] as! String
        objectID = dictionary[OTMClient.JSONResponseKeys.ObjectId] as! String
        uniqueKey = dictionary[OTMClient.JSONResponseKeys.UniqueKey] as! String
        updatedAt = dictionary[OTMClient.JSONResponseKeys.UpdatedAt] as! String
        
    }
    
    /* Helper: Given an array of dictionaries, convert them to an array of Student objects */
    static func locationsFromResults(results: [[String : AnyObject]]) -> [StudentLocations] {
        
        var locations = [StudentLocations]()
        
        for result in results {
            locations.append(StudentLocations(dictionary: result))
        }
        
        return locations
    }
}