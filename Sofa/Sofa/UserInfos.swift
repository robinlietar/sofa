//
//  UserInfos.swift
//  Sofa
//
//  Created by Robin Lietar on 31/10/2016.
//  Copyright © 2016 Sofa. All rights reserved.
//

import Foundation
import UIKit

class User: NSObject
{
    private var id:String?
    public var username:String?
    public var pwd:String?
    public var nom:String?
    private var prenom:String?
    public var affArrReco:[String]
    public var idArrReco:[String]
    public var firstImage:UIImage!
    public var secondImage:UIImage!
    public var thirdImage:UIImage!

    public required override init(){
        id = ""
        username = ""
        pwd = ""
        nom = "liet"
        prenom = ""
        affArrReco = []
        idArrReco = []
        
    }
    
    public convenience init(_username: String, _pwd: String){
        self.init()
        username = _username
        pwd = _pwd
    }
    
    public convenience init(_id: String, _username: String, _pwd: String, _nom: String, _prenom: String){
        self.init(_username: _username, _pwd: _pwd)
        id = _id
        nom = _nom
        prenom = _prenom
    }
    
    func addMovie(x: inout Int) {
        // Do stuff
    }
}
