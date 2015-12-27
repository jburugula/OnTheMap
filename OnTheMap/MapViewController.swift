//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Janaki Burugula on Dec/18/2015.
//  Copyright © 2015 janaki. All rights reserved.
//


import UIKit
import MapKit


class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
 
    
   override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
         self.getStudentLocations()
    }
    
    
    //Mark : Fetch Student Locations
    
    func getStudentLocations(){
        
        OTMClient.sharedInstance().getStudentLocations { (success: Bool, error: String?) -> Void in
            if success {
                dispatch_async(dispatch_get_main_queue()) {
                    self.generateMap()
                }
            } else {
                self.displayError("Error fetching locations", errorString: error!)
                
            }
        }
        
    }
    
    
    
    func generateMap()
    {
        // We will create an MKPointAnnotation for each dictionary in "locations". The
        // point annotations will be stored in this array, and then provided to the map view.
        var annotations = [MKPointAnnotation]()
        
        // The "locations" array is loaded with the sample data below. We are using the dictionaries
        // to create map annotations. This would be more stylish if the dictionaries were being
        // used to create custom structs. Perhaps StudentLocation structs.
        
        for dictionary in UserData.sharedInstance().locations {
            
            // Notice that the float values are being used to create CLLocationDegree values.
            // This is a version of the Double type.
            
            // Notice that the float values are being used to create CLLocationDegree values.
            // This is a version of the Double type.
            
            let lat = dictionary.latitude
            let long = dictionary.longitude
            
            // The lat and long are used to create a CLLocationCoordinates2D instance.
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let first = dictionary.firstName
            let last = dictionary.lastName
            let mediaURL = dictionary.mediaURL
            
            // Here we create the annotation and set its coordiate, title, and subtitle properties
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL
            
            // Finally we place the annotation in an array of annotations.
            annotations.append(annotation)
            
            
        }
        
        
        // When the array is complete, we add the annotations to the map.
        self.mapView.addAnnotations(annotations)
        
    }
    
    
    // MARK: - MKMapViewDelegate
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinColor = .Red
            pinView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.sharedApplication()
            if let toOpen = view.annotation?.subtitle! {
                app.openURL(NSURL(string: toOpen)!)
            }
        }
    }
    
    //Logout from Udacity account
    @IBAction func logoutBtnClick(sender: AnyObject) {
        
        OTMClient.sharedInstance().udacityLogout { (success: Bool, error: String?) -> Void in
            if success {
                self.dismissViewControllerAnimated(true, completion: nil)
            } else {
                self.displayError("Unable to log out", errorString: "Please try again.")
            }
        }
    }
    
    // Open the information posting view
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
    
    
    // Displays error message alert view.
    func displayError(title: String, errorString: String) {
        dispatch_async(dispatch_get_main_queue()) {
            let alertController = UIAlertController(title: title, message: errorString, preferredStyle: .Alert)
            let okAction = UIAlertAction (title: "OK", style: UIAlertActionStyle.Default, handler: nil)
            alertController.addAction(okAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    
    // Reload Student Locations
    @IBAction func refreshBtnClick(sender: AnyObject) {
        
        getStudentLocations()
    }
}
