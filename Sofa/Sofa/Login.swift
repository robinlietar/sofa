//
//  Login.swift
//  Sofa
//
//  Created by Robin Lietar on 31/10/2016.
//  Copyright © 2016 Sofa. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

class Login: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    public var user:User!
    public var username:String?
    private var password:String?
    private var loginAttempt:Bool?
    private var firstUse:Bool?

    var nc:NetworkCommunication!
    
    let notificationName = Notification.Name("Login.ConnexionSucceeded")
    let notificationName2 = Notification.Name("Login.ConnexionFailed")

    
    override func viewDidLoad() {
        super.viewDidLoad()
        username = ""
        password = ""
        loginAttempt = false
        firstUse = false
        
        usernameField.delegate = self
        passwordField.delegate = self
        
        // Keyboard moving
        
        NotificationCenter.default.addObserver(self, selector: #selector(Login.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(Login.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(Login.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
        
        //initNetwork()
        nc = NetworkCommunication()
        nc.currentVC = "Login"

        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    // MARK: Textfield functions
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //textField.resignFirstResponder()
        if (textField == usernameField){
            passwordField.becomeFirstResponder()
        }
        else {
            textField.resignFirstResponder()
            connexionAttempt()
            
            //let newUser = User.init(_login:username!, _pwd:password!)
            //let name = newUser.login
            //print("Le nom est de \(name)")
            
        }
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        if (textField == usernameField){
            username = textField.text
        }
        else {
            password = textField.text
        }
    }
    
    func connexionAttempt(){
        errorLabel.isHidden = true
        let messageString = "90;" + username! + ";" + password! + ";1;"
        print(messageString)
        nc.sendString(message: messageString)
        loginAttempt = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(Login.connexionSucceeded), name: notificationName, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(Login.connexionFailed), name: notificationName2, object: nil)
    }
    
    func connexionSucceeded() {
        user = User.init(_username:username!, _pwd:password!)
        let name = user.username
        print("Le nom est de \(name)")
        parseOutput()
        
        let manager = SDWebImageManager()
        var dwnldIm:Int = 0
        //typealias PrefetchingDone = (UIImage?, Error?, SDImageCacheType, Bool, URL?) -> Void
        
        if (firstUse)! {
        manager.downloadImage(with: NSURL(string: user.affArrReco[0]) as URL!, options: SDWebImageOptions(rawValue: 0), progress: nil, completed: { (image, error, bool, cache, url) in
            dwnldIm = dwnldIm + 1
            print("image  1")
            if (image != nil) {
                print("image not nil")
                self.user.firstImage = image
            }
            if (dwnldIm == 2){
                self.passToTindFilms()
            }
        })
        manager.downloadImage(with: NSURL(string: user.affArrReco[1]) as URL!, options: SDWebImageOptions(rawValue: 0), progress: nil, completed: { (image, error, bool, cache, url) in
            dwnldIm = dwnldIm + 1
            print("image  2")
            if (image != nil) {
                print("image not nil")
                self.user.secondImage = image
            }
            if (dwnldIm == 2){
                self.passToTindFilms()
            }
        })
        }
        NotificationCenter.default.removeObserver(self, name: notificationName, object: nil);
        NotificationCenter.default.removeObserver(self, name: notificationName2, object: nil);
        
    }
    
    func connexionFailed() {
        print("connexion failed")
        errorLabel.isHidden = false
        NotificationCenter.default.removeObserver(self, name: notificationName, object: nil);
        NotificationCenter.default.removeObserver(self, name: notificationName2, object: nil);
    }
    
    func passToTindFilms () {
        let mapViewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "TindFilm") as? TindFilm
        mapViewControllerObj?.user = user
        self.navigationController?.pushViewController(mapViewControllerObj!, animated: true)
    }
    
    
    
    func parseOutput(){
        print("outPutread" + nc.outputRead)
        print(nc.outputRead.characters.count)
        let fullNameArr = nc.outputRead.components(separatedBy: "::")

        if (fullNameArr.count == 2) {
            let mapViewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "HomeSofa") as? HomeSofa
            mapViewControllerObj?.user = user
            self.navigationController?.pushViewController(mapViewControllerObj!, animated: true)
        }
        else {
            let fullNameArr = nc.outputRead.components(separatedBy: "::")
            let idString = fullNameArr[1] as String
            let affString = fullNameArr[2] as String
            user.idArrReco = idString.components(separatedBy: ";")
            user.affArrReco = affString.components(separatedBy: ";")
            firstUse = true
        }
        
    }
    
    // MARK: Keyboard functions
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
            else {
                
            }
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if view.frame.origin.y != 0 {
                self.view.frame.origin.y += keyboardSize.height
            }
            else {
                
            }
        }
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        // Hide the navigation bar on the this view controller
    }
    override func viewWillDisappear(_ animated: Bool) {
        // Show the navigation bar on other view controllers
    }
    
}

