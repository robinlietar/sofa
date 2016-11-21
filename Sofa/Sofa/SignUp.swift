//
//  SignUp.swift
//  Sofa
//
//  Created by Robin Lietar on 31/10/2016.
//  Copyright © 2016 Sofa. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

class SignUp: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBAction func goSender(_ sender: Any) {
        connexionAttempt()
    }
    
    
    public var user:User!
    public var username:String?
    private var password:String?
    private var signUpAttempt:Bool?

    var nc:NetworkCommunication!

    let notificationName = Notification.Name("SignUp.ConnexionSucceeded")
    let notificationName2 = Notification.Name("SignUp.ConnexionFailed")

    override func viewDidLoad() {
        super.viewDidLoad()

        username = ""
        password = ""
        signUpAttempt = false
        
        usernameField.delegate = self
        passwordField.delegate = self
        
        // Keyboard moving
        
        NotificationCenter.default.addObserver(self, selector: #selector(SignUp.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SignUp.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SignUp.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
        
        //initNetwork()
        nc = NetworkCommunication()
        nc.currentVC = "SignUp"

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
        let messageString = "90;" + username! + ";" + password! + ";0;"
        print(messageString)
        nc.sendString(message: messageString)
        signUpAttempt = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(SignUp.connexionSucceeded), name: notificationName, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(SignUp.connexionFailed), name: notificationName2, object: nil)
            }
    
    func connexionSucceeded() {
        user = User.init(_username:username!, _pwd:password!)
        let name = user.username
        print("Le nom est de \(name)")
        parseOutput()
        
        let manager = SDWebImageManager()
        var dwnldIm:Int = 0
        //typealias PrefetchingDone = (UIImage?, Error?, SDImageCacheType, Bool, URL?) -> Void

        
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
        let fullNameArr = nc.outputRead.components(separatedBy: "::")
        let idString = fullNameArr[1] as String
        let affString = fullNameArr[2] as String
        user.idArrReco = idString.components(separatedBy: ";")
        user.affArrReco = affString.components(separatedBy: ";")
        
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
    
    /*func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        if (segue.identifier == "TindFilm") {
            //get a reference to the destination view controller
            let destinationVC:TindFilm = segue.destination as! TindFilm
            
            //set properties on the destination view controller
            destinationVC.user = user
            //etc...
        }
    }
    */
    
    
    
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
