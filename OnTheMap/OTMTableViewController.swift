//
//  OTMTableViewController.swift
//  OnTheMap
//
//  Created by Janaki Burugula on Dec/19/2015.
//  Copyright © 2015 janaki. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class OTMTableViewController: UITableViewController{
    
    @IBOutlet var studentTable: UITableView!
    
    @IBOutlet weak var logoutBtn: UIBarButtonItem!
    
    @IBOutlet weak var pinBtn: UIBarButtonItem!
    
    @IBOutlet weak var refreshBtn: UIBarButtonItem!
    
    var locations: [StudentLocations] = [StudentLocations]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(OTMClient.sharedInstance().locations.count > 0) {
            
            locations = OTMClient.sharedInstance().locations
            studentTable.reloadData()
        }
        else
        {
            getStudentLocations()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        studentTable.reloadData()
    }
    
    
    //Mark : Fetch Student Locations
    
    func getStudentLocations(){
        
        OTMClient.sharedInstance().getStudentLocations{ studentLocation, error in
            if let studentLocation = studentLocation {
                
                OTMClient.sharedInstance().locations = studentLocation
                self.locations = studentLocation
                dispatch_async(dispatch_get_main_queue()) {
                    self.studentTable.reloadData()
                }
            } else {
                self.displayError("Error fetching locations", errorString: error!)
            }
        }
        
    }
    
    // Default number of sections in Table to one
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    // Return number of Rows
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    // set details for the selected Cell
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("StudentTableCell") as! StudentTableCell
        
        let namecell = locations[indexPath.row]
        
        let firstname = namecell.firstName
        let lastname = namecell.lastName
        
        cell.studentName.text =  firstname + " " + lastname
        return cell
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let location = locations[indexPath.row]
        let mediaURL = location.mediaURL
        let app = UIApplication.sharedApplication()
        app.openURL(NSURL(string: mediaURL)!)
        
    }
    
    
    
    @IBAction func logoutBtnClick(sender: AnyObject) {
        
        OTMClient.sharedInstance().udacityLogout { (success: Bool, error: String?) -> Void in
            if success {
                self.dismissViewControllerAnimated(true, completion: nil)
            } else {
                self.displayError("Unable to log out", errorString: "Please try again.")
            }
        }
    }
    
    // Displays error message alert view.
    func displayError(title: String, errorString: String) {
        dispatch_async(dispatch_get_main_queue()) {
            let alertController = UIAlertController(title: title, message: errorString, preferredStyle: .Alert)
            let okAction = UIAlertAction (title: "OK", style: UIAlertActionStyle.Default, handler: nil)
            alertController.addAction(okAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func pinBtnClick(sender: AnyObject) {
        
        OTMClient.sharedInstance().getCurrentUserInfo { (success: Bool, error: String) -> Void in
            if success {
                dispatch_async(dispatch_get_main_queue()) {
                    let controller = self.storyboard!.instantiateViewControllerWithIdentifier("PostStudentLocations")
                    self.presentViewController(controller, animated: true, completion: nil)
                    
                }
            } else {
                self.displayError("Could not handle request.", errorString: error)
            }
            
        }
        
        
    }
    // Reload the Student Locations
    @IBAction func refreshBtnClick(sender: AnyObject) {
        
        getStudentLocations()
        
    }
    
    
}

