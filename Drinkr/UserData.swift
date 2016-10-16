//
//  UserData.swift
//  Connect App
//
//  Created by Dustin Allen on 7/4/16.
//  Copyright © 2016 Harloch. All rights reserved.
//

import Foundation
struct UserData
{
    var venueName: String?
    var photoURL: String?
    var uid: String?
    var image: UIImage?
    var approvalStatus: String?
    var noImage: Bool?
    var venueOpenUntil: String?
    
    // Mark: Init
    init(let venueName: String, let photoURL: String, let uid: String, let image: UIImage, let approvalStatus: String, let noImage: Bool, let venueOpenUntil: String) {
        self.venueName = venueName
        self.photoURL = photoURL
        self.uid = uid
        self.image = image
        self.approvalStatus = approvalStatus
        self.noImage = noImage
        self.venueOpenUntil = venueOpenUntil
    }
    
    // Mark: Get User Name
    func getVenueName() -> String {
        return self.venueName!
    }
    
    // Mark: Get User Profile Photo URL
    func getUserPhotoURL() -> String {
        return self.photoURL!
    }
    
    // Mark: Get User uid
    func getUid() -> String {
        return self.uid!
    }
    
    // Mark: Get User image
    func getImage() -> UIImage {
        return self.image!
    }
    
    // Mark: Get User email
    func getApprovalStatus() -> String {
        return self.approvalStatus!
    }
    
    // Mark: check whether profile image exist
    func imageExist() -> Bool {
        return !self.noImage!
    }
    
    func getVenueOpenUntil() -> String {
        return self.venueOpenUntil!
    }
}