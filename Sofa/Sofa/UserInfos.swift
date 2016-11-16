//
//  UserInfos.swift
//  Sofa
//
//  Created by Robin Lietar on 31/10/2016.
//  Copyright © 2016 Sofa. All rights reserved.
//

import Foundation

class User: NSObject
{
    private var id:String?
    public var login:String?
    private var pwd:String?
    public var nom:String?
    private var prenom:String?
    
    public required override init(){
        id = ""
        login = ""
        pwd = ""
        nom = "liet"
        prenom = ""
    }
    
    public convenience init(_login: String, _pwd: String){
        self.init()
        login = _login
        pwd = _pwd
    }
    
    public convenience init(_id: String, _login: String, _pwd: String, _nom: String, _prenom: String){
        self.init(_login: _login, _pwd: _pwd)
        id = _id
        nom = _nom
        prenom = _prenom
    }
    
    func addMovie(x: inout Int) {
        // Do stuff
    }
}
