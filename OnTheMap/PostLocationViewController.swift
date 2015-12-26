//
//  PostLocationViewController.swift
//  OnTheMap
//
//  Created by Janaki Burugula on Dec/22/2015.
//  Copyright © 2015 janaki. All rights reserved.
//

import UIKit
import MapKit

class PostLocationViewController: UIViewController , UITextFieldDelegate{

    @IBAction func cancelBtnClick(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        

    }
    @IBOutlet weak var studyLabel: UILabel!
    @IBOutlet weak var enterLocText: UITextField!
    
    @IBOutlet weak var enterLnkText: UITextField!
    
    @IBOutlet weak var findMapBtn: UIButton!
    
    @IBOutlet weak var submitLocBtn: UIButton!
    @IBOutlet weak var studentMapView: MKMapView!
    
    @IBOutlet weak var activityInd: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.studentMapView.hidden = true
        self.submitLocBtn.hidden = true
        self.enterLnkText.hidden = true
        self.activityInd.hidesWhenStopped = true
        
        // Text field delegates
        self.enterLocText.delegate = self
        self.enterLnkText.delegate = self
       
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeToKeyboardNotifications()
    }
    
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        view.frame.origin.y = -getKeyboardHeight(notification)
        
    }
    
    
    func keyboardWillHide(notification: NSNotification) {
        view.frame.origin.y = 0
    }
    
    
    // Get the height of the keyboard
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        if enterLnkText.isFirstResponder() {
            return 0
            
        } else {
            
           return keyboardSize.CGRectValue().height
        }
        
    }

    // Dismisses the keyboard when you press return (the bottom right key)
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func submitLocBtnClick(sender: AnyObject) {
        
        
        if enterLnkText.text!.isEmpty {
            self.displayError("Website link is required", errorString: "Please enter a link to share.")
        }
            else {
            
            
            UserData.sharedInstance().mediaURL = enterLnkText.text
            
            
            OTMClient.sharedInstance().postStudentLocation({(success,error) in
                    if (success) {
                        self.dismissViewControllerAnimated(true, completion: nil)
                        
                    } else {
                        self.displayError("Could not post location", errorString: "Unable to Post Data")
                        return
                }
            })
     
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

    
    @IBAction func findMapBtnClick(sender: AnyObject) {
        
        if enterLocText.text != nil {
            
            self.makeTransparent()
            
            UserData.sharedInstance().mapString = enterLocText.text
            activityInd.startAnimating()
            
            let studentLoc = enterLocText.text
            let geocoder = CLGeocoder()
            
            geocoder.geocodeAddressString(studentLoc!, completionHandler: {(placemarks: [CLPlacemark]?, error: NSError?) -> Void in
                if let placemark = placemarks?[0] {
                    
                    UserData.sharedInstance().region = self.zoomToRegion(placemarks!)
                    self.setupLinkView()
                    self.studentMapView.addAnnotation(MKPlacemark(placemark: placemark))
                    let annotation = MKPointAnnotation()
                    let latitude = UserData.sharedInstance().region.center.latitude
                    let longitude = UserData.sharedInstance().region.center.longitude
                    annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                    
                    
                    self.studentMapView.setRegion(UserData.sharedInstance().region, animated: true)
                    self.studentMapView.addAnnotation(annotation)
                    self.returnTransparency()
                    self.activityInd.stopAnimating()
                }
                else
                {
                    let alert = UIAlertController(title: "Sorry!", message: "Location Not Found", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                    self.returnTransparency()
                    self.activityInd.stopAnimating()
                }
                
                
            })
        }
        else {
            let alert = UIAlertController(title: "Error!", message: "Please enter Location ", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            self.returnTransparency()
            self.activityInd.stopAnimating()
            
        }
        
    }
    
    // Zoom to  the provided location.
    func zoomToRegion(placemarks: [CLPlacemark]) -> MKCoordinateRegion? {
        
        var regions = [MKCoordinateRegion]()
        
        for placemark in placemarks {
            
            let coordinate: CLLocationCoordinate2D = placemark.location!.coordinate
            let span: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
            
            regions.append(MKCoordinateRegion(center: coordinate, span: span))
        }
        
        return regions.first
    }

    // Sets up Link View
    func setupLinkView() {
        
        self.studentMapView.hidden = false
        self.enterLocText.hidden = true
        self.findMapBtn.hidden = true
        self.submitLocBtn.hidden = false
        self.enterLnkText.hidden = false
        self.studyLabel.hidden = true
        self.activityInd.stopAnimating()
    }
    
    
    // Makes map transparent while geocoding
    func makeTransparent(){
        self.studentMapView.alpha = 0.5
        submitLocBtn.alpha = 0.5
    }
    
    // Makes map visible when geocoding is complete.
    func returnTransparency() {
        self.studentMapView.alpha = 1.0
        submitLocBtn.alpha = 1.0
    }
    
}