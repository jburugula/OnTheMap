//
//  OTMConstants.swift
//  OnTheMap
//
//  Created by Janaki Burugula on Dec/15/2015.
//  Copyright © 2015 janaki. All rights reserved.
//

import Foundation

extension OTMClient {

    
    struct Constants {
        
        //  API Key
        static let ParseAppID: String = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let ParseAPIKey: String = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        
        //  URLs
         static let udacityBaseURLSecure : String = "https://www.udacity.com/api/"
         static let parseBaseURLSecure : String = "https://api.parse.com/1/classes/StudentLocation"
        
        
    }
    struct ParameterKeys {
        
        static let ParseApiKey = "X-Parse-REST-API-Key"
        
        static let ParseApplicationID = "X-Parse-Application-Id"
        
    }
    
    struct JSONResponseKeys {
        
      
        // Udacity General
        static let Account = "account"
        static let Results = "results"
        static let UserID = "key"
        static let Registered = "registered"
        static let Error = "error"
        
        
        
        // Udacity User
        static let User = "user"
        static let UserFirstName = "first_name"
        static let UserLastName = "last_name"
        
        // Student Locations
        static let CreatedAt = "createdAt"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        static let MapString = "mapString"
        static let MediaURL = "mediaURL"
        static let ObjectId = "objectId"
        static let UniqueKey = "uniqueKey"
        static let UpdatedAt = "updatedAt"
    }      
    
    
    struct Methods {
        
        static let udacitySession: String = "session"
        static let UdacityData: String = "users/"
        static let UpdatedAt: String = "&order=-updatedAt"
        static let limit: String = "?limit=100"
        
         
    }
}