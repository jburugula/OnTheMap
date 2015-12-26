//
//  OTMConvenience.swift
//  OnTheMap
//
//  Created by Janaki Burugula on Dec/15/2015.
//  Copyright © 2015 janaki. All rights reserved.
//

import Foundation
import UIKit


extension OTMClient {
    
    
    // Login to Udacity and get User Id.
    
    func udacityLogin(username: String, password: String, completionHandler: (success: Bool, errorString: String?) -> Void) {
        
        // Set the variables
        let parameters = [String: AnyObject]()
        let baseURL = OTMClient.Constants.udacityBaseURLSecure
        let method = OTMClient.Methods.udacitySession
        let jsonBody = ["udacity": ["username": username, "password" : password]]
        
        // Make the request
        self.taskForPOSTMethod(parameters, baseURL: baseURL, method: method, jsonBody: jsonBody) { result, error in
            // Send the desired value(s) to completion handler
            if let _ = error {
                completionHandler(success: false, errorString: "Please check your network connection and try again.")
            } else {
                if let resultDictionary = result.valueForKey(OTMClient.JSONResponseKeys.Account) as? NSDictionary {
                    if let userID = resultDictionary.valueForKey(OTMClient.JSONResponseKeys.UserID) as? String {
                        NSUserDefaults.standardUserDefaults().setObject(userID, forKey: "UdacityUserID")
                        UserData.sharedInstance().objectID = userID
                        completionHandler(success: true, errorString: "successful")
                    }
                } else {
                    completionHandler(success: false, errorString: "Username or password is incorrect.")
                }
            }
        }
    }
    
    
    
    
    // Logout of Udacity.
    func udacityLogout(completionHandler: (success: Bool, error: String?) -> Void) {
        
        // Build the URL and configure the request
        let method = OTMClient.Methods.udacitySession
        let request = NSMutableURLRequest(URL: NSURL(string: OTMClient.Constants.udacityBaseURLSecure + method)!)
        request.HTTPMethod = "DELETE"
        var xsrfCookie: NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for cookie in (sharedCookieStorage.cookies! as? [NSHTTPCookie])! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        // Make the request
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            // Send the desired value(s) to completion handler
            if error != nil {
                completionHandler(success: false, error: "Could not logout.")
                return
            }
            _ = data!.subdataWithRange(NSMakeRange(5, data!.length - 5))
            completionHandler(success: true, error: nil)
        }
        task.resume()
    }
    
    
    
    // Get student location data from Parse.
    func getStudentLocations(completionHandler: (result: [StudentLocations]?, errorString: String?) -> Void) {
        
        // Set the variables
        let parameters = [String: AnyObject]()
        let baseURL = Constants.parseBaseURLSecure
        let updatedAt = Methods.UpdatedAt
        let limit = Methods.limit
        let method = limit+updatedAt
        let key = ""
        
        self.taskForGETMethod(parameters, baseURL: baseURL, method: method, key: key) { result, error in
            // Send the desired value(s) to completion handler
            if let _ = error {
                completionHandler(result: nil, errorString: "Please check your network connection, then tap refresh to try again.")
            } else {
                if let results = result.valueForKey(OTMClient.JSONResponseKeys.Results) as? [[String : AnyObject]] {
                    let studentLocations = StudentLocations.locationsFromResults(results)
                    completionHandler(result: studentLocations, errorString: "successful")
                } else {
                    completionHandler(result: nil, errorString: "Server error. Please tap refresh to try again.")
                }
            }
        }
    }
    
    
    
    func postStudentLocation(completionHandler: (success: Bool, errorString: String?) -> Void) {
        
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let parameters = [String: AnyObject]()
        let baseURL = Constants.parseBaseURLSecure
        let method = ""
        
        let jsonBody: [String: AnyObject] = [
            "uniqueKey": UserData.sharedInstance().objectID,
            "firstName": UserData.sharedInstance().userFirstName,
            "lastName": UserData.sharedInstance().userLastName,
            "mapString": UserData.sharedInstance().mapString,
            "mediaURL": UserData.sharedInstance().mediaURL,
            "latitude": UserData.sharedInstance().region.center.latitude,
            "longitude": UserData.sharedInstance().region.center.longitude
        ]
        
        self.taskForPOSTMethod(parameters, baseURL: baseURL, method: method, jsonBody: jsonBody) { result, error in
            
            if let _ = error {
                completionHandler(success: false, errorString: "There is an error posting Student Location. Please Check")
                
            } else {
                if let results = result.valueForKey(OTMClient.JSONResponseKeys.ObjectId) as? String {
                    
                    UserData.sharedInstance().objectID = results
                    completionHandler(success: true, errorString: "Data posted successful")
                } else {
                    completionHandler(success: false, errorString: "Please try again.")
                }
                
            }
        }
        
    }
    
    
    // Get looged in user's  data from Udacity.
    func getCurrentUserInfo(completionHandler: (success: Bool, error: String) -> Void) {
        
        // Set the variables
        let parameters = [String: AnyObject]()
        let baseURL = Constants.udacityBaseURLSecure
        let method = Methods.UdacityData
        let key = NSUserDefaults.standardUserDefaults().stringForKey("UdacityUserID")!
        
        // Make the request
        self.taskForGETMethod(parameters, baseURL: baseURL, method: method, key: key) { result, error in
            // Send the desired value(s) to completion handler
            if let _ = error {
                completionHandler(success: false, error: "Unable to fetch User Profile")
            } else {
                if let userDictionary = result.valueForKey(OTMClient.JSONResponseKeys.User) as? NSDictionary {
                    if let firstName = userDictionary.valueForKey(OTMClient.JSONResponseKeys.UserFirstName) as? String {
                        UserData.sharedInstance().userFirstName = firstName
                        if let lastName = userDictionary.valueForKey(OTMClient.JSONResponseKeys.UserLastName) as? String {
                            UserData.sharedInstance().userLastName = lastName
                            completionHandler(success: true, error: "successful")
                        }
                    }
                } else {
                    completionHandler(success: false, error: "Server error. Please try again.")
                }
            }
        }
    }
    
    
}
