//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Janaki Burugula on Dec/13/2015.
//  Copyright © 2015 janaki. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController , UITextFieldDelegate{
    
    @IBOutlet weak var userNameText: UITextField!
    @IBOutlet weak var passWordText: UITextField!
    @IBOutlet weak var debugLabel: UILabel!
    
    @IBOutlet weak var hdrLabel: UILabel!
    
    @IBOutlet weak var loginBtn: UIButton!
    
    var appDelegate: AppDelegate!
    var session: NSURLSession!
    
    var usrName:String!
    var passWord:String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        /* Get the app delegate */
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        /* Get the shared URL session */
        session = NSURLSession.sharedSession()
        
        // Text field delegates
        self.userNameText.delegate = self
        self.passWordText.delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.debugLabel.text = ""
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeToKeyboardNotifications()
    }
    
    @IBAction func signUpBtn(sender: AnyObject) {
        
        UIApplication.sharedApplication().openURL(NSURL(string: "https://www.udacity.com/account/auth#!/signin")!)
    }
    
    @IBAction func loginBtnClick(sender: AnyObject) {
        
        if userNameText.text!.isEmpty {
            debugLabel.text = "Username Empty."
        } else if passWordText.text!.isEmpty {
            debugLabel.text = "Password Empty."
        } else {
            
            usrName = userNameText.text
            passWord = passWordText.text
            
            userNameText.resignFirstResponder()
            passWordText.resignFirstResponder()
            OTMClient.sharedInstance().udacityLogin(usrName!, password: passWord!, completionHandler: { (success, errorString) -> Void in
                if success {
                    dispatch_async(dispatch_get_main_queue(), {
                        self.completeLogin()
                    })
                } else {
                    dispatch_async(dispatch_get_main_queue(), {
                        self.displayError(errorString!)
                    })
                }
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    // Dismisses the keyboard when you press return
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // Get the height of the keyboard
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
        
    }
    
    
    
    // Error alert notification.
    func displayError(errorString: String) {
        dispatch_async(dispatch_get_main_queue()) {
            let alertController = UIAlertController(title: "Could not log in.", message: errorString, preferredStyle: .Alert)
            let okAction = UIAlertAction (title: "OK", style: UIAlertActionStyle.Default, handler: nil)
            alertController.addAction(okAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    
    // Clears text fields and gets MapViewController.
    
    func completeLogin() {
        self.userNameText.text = ""
        self.passWordText.text = ""
        self.getTabController()
    }
    
    
    // Gets MapViewController.
    func getTabController() {
        let controller = self.storyboard!.instantiateViewControllerWithIdentifier("mapTabBarController") as! UITabBarController
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    
}

