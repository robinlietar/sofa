//
//  CreateSofa.swift
//  Sofa
//
//  Created by Robin Lietar on 31/10/2016.
//  Copyright © 2016 Sofa. All rights reserved.
//

import Foundation
import UIKit
import FBSDKLoginKit

class CreateSofa: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    public var user:User!
    public var sofaName:String?
    var nc:NetworkCommunication!
    let notificationName = Notification.Name("CreateSofa.ConnexionSucceeded")
    let notificationName2 = Notification.Name("CreateSofa.ConnexionFailed")
    
    @IBAction func goSender(_ sender: Any) {
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sofaName = ""
        // Keyboard moving
        
        NotificationCenter.default.addObserver(self, selector: #selector(CreateSofa.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CreateSofa.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CreateSofa.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
        
        //initNetwork()
        nc = NetworkCommunication()
        nc.currentVC = "CreateSofa"
        
        
        // Do any additional setup after loading the view, typically from a nib.
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
    
    // MARK: Textfield functions
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //textField.resignFirstResponder()
 
        textField.resignFirstResponder()
        connexionAttempt()
            
            //let newUser = User.init(_login:username!, _pwd:password!)
            //let name = newUser.login
            //print("Le nom est de \(name)")
            
        
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        sofaName = textField.text
        
    }
    
    func connexionAttempt(){
        errorLabel.isHidden = true
        let messageString = "10;" + sofaName! + ";"
        print(messageString)
        nc.sendString(message: messageString)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(CreateSofa.connexionSucceeded), name: notificationName, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(CreateSofa.connexionFailed), name: notificationName2, object: nil)
    }
    
    func connexionSucceeded() {
 
        
        NotificationCenter.default.removeObserver(self, name: notificationName, object: nil);
        NotificationCenter.default.removeObserver(self, name: notificationName2, object: nil);
        
    }
    
    func connexionFailed() {
        print("connexion failed")
        errorLabel.isHidden = false
        NotificationCenter.default.removeObserver(self, name: notificationName, object: nil);
        NotificationCenter.default.removeObserver(self, name: notificationName2, object: nil);
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.setToolbarHidden(true, animated: true)

        
    }
    override func viewWillDisappear(_ animated: Bool) {
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
}
