//
//  VenueLoginViewController.swift
//  Drinkr
//
//  Created by Dustin Allen on 10/10/16.
//  Copyright © 2016 Harloch. All rights reserved.
//

import UIKit
import Firebase

class VenueLoginViewController: UIViewController {
    
    @IBOutlet var username: UITextField!
    @IBOutlet var passwordField: UITextField!
    
    var ref:FIRDatabaseReference!
    var user: FIRUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = FIRDatabase.database().reference()
        user = FIRAuth.auth()?.currentUser
        
        /*
        if let user = FIRAuth.auth()?.currentUser {
            self.signedIn(user)
        }*/
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginButton(sender: AnyObject) {
        let email = username.text!
        let password = passwordField.text!
        if email.isEmpty || password.isEmpty {
            CommonUtils.sharedUtils.showAlert(self, title: "Error", message: "Email or password is missing.")
        }
        else{
            CommonUtils.sharedUtils.showProgress(self.view, label: "Signing in...")
            FIRAuth.auth()?.signInWithEmail(email, password: password) { (user, error) in
                dispatch_async(dispatch_get_main_queue(), {
                    CommonUtils.sharedUtils.hideProgress()
                })
                if let error = error {
                    CommonUtils.sharedUtils.showAlert(self, title: "Error", message: error.localizedDescription)
                    print(error.localizedDescription)
                }
                else{
                    let next = self.storyboard?.instantiateViewControllerWithIdentifier("VenueInformationViewController") as! VenueInformationViewController!
                    self.navigationController?.pushViewController(next, animated: true)
                }
            }
        }
    }
    
    @IBAction func registerButton(sender: AnyObject) {
        let next = self.storyboard?.instantiateViewControllerWithIdentifier("VenueRegisterViewController") as! VenueRegisterViewController!
        self.navigationController?.pushViewController(next, animated: true)
    }
    
    @IBAction func backButton(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func signedIn(user: FIRUser?) {
        let next = self.storyboard?.instantiateViewControllerWithIdentifier("VenueInformationViewController") as! VenueInformationViewController!
        self.navigationController?.pushViewController(next, animated: true)
    }
    
}
