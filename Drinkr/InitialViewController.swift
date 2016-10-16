//
//  InitialViewController.swift
//  Drinkr
//
//  Created by Dustin Allen on 10/5/16.
//  Copyright © 2016 Harloch. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKShareKit
import Firebase

class InitialViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    @IBOutlet var loginButton: FBSDKLoginButton!
    
    var ref:FIRDatabaseReference!
    var user: FIRUser!
    var fbId: String?
    
    var facebookData: Dictionary<String, AnyObject>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        ref = FIRDatabase.database().reference()
        user = FIRAuth.auth()?.currentUser
        
        var loginView : FBSDKLoginButton = FBSDKLoginButton()
        loginView = loginButton
        self.view.addSubview(loginView)
        //loginView.center = self.view.center
        loginView.readPermissions = ["public_profile", "email", "user_friends"]
        loginView.delegate = self
        
        if (FBSDKAccessToken.currentAccessToken() != nil)
        {
            print (FBSDKAccessToken.currentAccessToken().permissions)
            
        }
        
        /*
        if (FIRAuth.auth()?.currentUser) != nil {
            let next = self.storyboard?.instantiateViewControllerWithIdentifier("MapViewController") as! MapViewController!
            self.navigationController?.pushViewController(next, animated: true)
        } else {
            print("Not Signed In")
        }*/
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func venueLogin(sender: AnyObject) {
        let next = self.storyboard?.instantiateViewControllerWithIdentifier("VenueLoginViewController") as! VenueLoginViewController!
        self.navigationController?.pushViewController(next, animated: true)
    }
    
    func showFriendData()
    {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me/taggable_friends?limit=999", parameters: ["fields" : "name"])
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                // Process error
                print("Error: \(error)")
            }
            else
            {
                if let friends : NSArray = result.valueForKey("data") as? NSArray{
                    let i = 1
                    for obj in friends {
                        if let name = obj["name"] as? String {
                            print("\(i) " + name)
                            var iChange = i
                            iChange += 1
                        }
                    }
                }
            }
        })
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        print("User Logged In")

        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields" : "id, name, gender, first_name, last_name, locale, email"])
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            let token = FBSDKAccessToken.currentAccessToken().tokenString
            
            let credential = FIRFacebookAuthProvider.credentialWithAccessToken(token)
            //CommonUtils.sharedUtils.showProgress(self.view, label: "Uploading Information...")
            FIRAuth.auth()?.signInWithCredential(credential, completion: { (user, error) in
                if error != nil {
                    print(error?.localizedDescription)
                    print("Something is wrong!!!!")
                    CommonUtils.sharedUtils.hideProgress()
                }
                
                print("fetched user: \(result)")
                self.fbId = result.valueForKey("id") as? String
                self.facebookData = ["userId": result.valueForKey("id") as? String ?? "","userFirstName": result.valueForKey("first_name") as? String ?? "", "userLastName": result.valueForKey("last_name") as? String ?? "", "gender": result.valueForKey("gender") as? String ?? "", "email": result.valueForKey("email") as? String ?? ""]
                print("Facebook Integration Data : \(self.facebookData)")
                print(self.facebookData)
                
                self.ref.child("users").child(user!.uid).setValue(["facebookData": ["userFirstName": result.valueForKey("first_name") as! String!, "userLastName": result.valueForKey("last_name") as! String!, "gender": result.valueForKey("gender") as! String!, "email": result.valueForKey("email") as! String!], "userFirstName": result.valueForKey("first_name") as! String!, "userLastName": result.valueForKey("last_name") as! String!])
                if let picture = result.objectForKey("picture") {
                    if let pictureData = picture.objectForKey("data"){
                        if let pictureURL = pictureData.valueForKey("url") {
                            print(pictureURL)
                            
                            self.ref.child("users").child(self.user!.uid).child("facebookData").child("profilePhotoURL").setValue(pictureURL)
                            
                                    }
                                }
                            }
                /*
                let next = self.storyboard?.instantiateViewControllerWithIdentifier("Segue1") as! UINavigationController!
                self.navigationController?.pushViewController(next, animated: true)*/
                self.performSegueWithIdentifier("Segue1", sender: self)
                
                if ((error) != nil)
                {
                    // Process error
                    print("Error: \(error)")
                }
                else
                {
                    let userName : NSString = result.valueForKey("name") as! NSString
                    print("User Name is: \(userName)")
                    
                    if let userEmail : NSString = result.valueForKey("email") as? NSString {
                        print("User Email is: \(userEmail)")
                    }
                }
            })
        })
        
        if ((error) != nil)
        {
            // Process error
        }
        else if result.isCancelled {
            // Handle cancellations
        }
        else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if result.grantedPermissions.contains("email")
            {
                // Do work
            }
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User Logged Out")
    }
}
