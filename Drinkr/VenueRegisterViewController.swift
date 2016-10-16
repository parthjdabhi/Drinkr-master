//
//  VenueRegisterViewController.swift
//  Drinkr
//
//  Created by Dustin Allen on 10/6/16.
//  Copyright © 2016 Harloch. All rights reserved.
//

import UIKit
import Firebase

class VenueRegisterViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var venueName: UITextField!
    @IBOutlet var managersName: UITextField!
    @IBOutlet var cityField: UITextField!
    @IBOutlet var townField: UITextField!
    @IBOutlet var postcode: UITextField!
    @IBOutlet var email: UITextField!
    @IBOutlet var venueTelephone: UITextField!
    @IBOutlet var contactNumber: UITextField!
    @IBOutlet var venueFacebook: UITextField!
    @IBOutlet var username: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var verifyPassword: UITextField!
    
    let isApproved = "Pending"
    
    var ref:FIRDatabaseReference!
    var user: FIRUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = FIRDatabase.database().reference()
        user = FIRAuth.auth()?.currentUser
        
        self.venueName.delegate = self
        self.managersName.delegate = self
        self.cityField.delegate = self
        self.townField.delegate = self
        self.postcode.delegate = self
        self.email.delegate = self
        self.venueTelephone.delegate = self
        self.contactNumber.delegate = self
        self.venueFacebook.delegate = self
        self.username.delegate = self
        self.password.delegate = self
        self.verifyPassword.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func registerButton(sender: AnyObject) {
        
        let email = self.email.text!
        let password = self.password.text!
        
        if venueName.text == "" {
            CommonUtils.sharedUtils.showAlert(self, title: "Error", message: "Please Enter The Venue Name.")
        }
        if managersName.text == "" {
            CommonUtils.sharedUtils.showAlert(self, title: "Error", message: "Please Enter The Manager's Name.")
        }
        if cityField.text == "" {
            CommonUtils.sharedUtils.showAlert(self, title: "Error", message: "Please Enter The City.")
        }
        if townField.text == "" {
            CommonUtils.sharedUtils.showAlert(self, title: "Error", message: "Please Enter The Town.")
        }
        if postcode.text == "" {
            CommonUtils.sharedUtils.showAlert(self, title: "Error", message: "Please Enter The Postcode.")
        }
        if venueTelephone.text == "" {
            CommonUtils.sharedUtils.showAlert(self, title: "Error", message: "Please Enter The Venue's Telephone.")
        }
        if contactNumber.text == "" {
            CommonUtils.sharedUtils.showAlert(self, title: "Error", message: "Please Enter The Venue's Best Contact Number.")
        }
        if venueFacebook.text == "" {
            CommonUtils.sharedUtils.showAlert(self, title: "Error", message: "Please Enter The Venue's Facebook Page.")
        }
        if password != verifyPassword.text {
            CommonUtils.sharedUtils.showAlert(self, title: "Error", message: "Your Passwords Don't Match.")
        }

        if email != "" && password != "" && venueName.text != "" && managersName.text != "" && cityField.text != "" && townField.text != "" && postcode.text! != "" && venueTelephone.text != "" && contactNumber.text != "" && venueFacebook != "" && username.text != "" && verifyPassword.text != "" {
            CommonUtils.sharedUtils.showProgress(self.view, label: "Registering...")
            FIRAuth.auth()?.createUserWithEmail(email, password: password, completion:  { (user, error) in
                if error == nil {
                    FIREmailPasswordAuthProvider.credentialWithEmail(email, password: password)
                    self.ref.child("venues").child(user!.uid).setValue(["venueName": self.venueName.text!, "managerName": self.managersName.text!, "city": self.cityField.text!, "town": self.townField.text!, "postcode": self.postcode.text!, "email": email, "venueTelephone": self.venueTelephone.text!, "contactNumber": self.contactNumber.text!, "venueFacebook": self.venueFacebook.text!, "username": self.username.text!, "approvalStatus": self.isApproved, "venueAddress": "Enter Your Address", "venueOpenUntil": "Enter Your Hours", "drinkForLike": "No Drink For Like Specials", "drinkForCheckIn": "No Drink For Check-In Specials"])
                    CommonUtils.sharedUtils.hideProgress()
                    let photoViewController = self.storyboard?.instantiateViewControllerWithIdentifier("VenueInformationViewController") as! VenueInformationViewController!
                    self.navigationController?.pushViewController(photoViewController, animated: true)
                } else {
                    dispatch_async(dispatch_get_main_queue(), {() -> Void in
                        CommonUtils.sharedUtils.hideProgress()
                        CommonUtils.sharedUtils.showAlert(self, title: "Error", message: (error?.localizedDescription)!)
                    })
                }
            })
        } else {
            let alert = UIAlertController(title: "Error", message: "Enter email & password!", preferredStyle: .Alert)
            let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alert.addAction(action)
        }
    }
}
