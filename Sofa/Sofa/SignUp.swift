//
//  SignUp.swift
//  Sofa
//
//  Created by Robin Lietar on 31/10/2016.
//  Copyright © 2016 Sofa. All rights reserved.
//

import Foundation
import UIKit

class SignUp: UIViewController, UITextFieldDelegate, StreamDelegate {
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    

    public var username:String?
    private var password:String?
    private var signUpAttempt:Bool?

    let serverAddress: CFString = "localhost" as CFString
    let serverPort: UInt32 = 8000
    
    private var inputStream : InputStream!
    private var outputStream : OutputStream!


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
        
        initNetwork()
    }
    
    // MARK: Network functions
    
    func initNetwork() {
        var readStream:  Unmanaged<CFReadStream>?
        var writeStream: Unmanaged<CFWriteStream>?
        
        CFStreamCreatePairWithSocketToHost(nil, self.serverAddress, self.serverPort, &readStream, &writeStream)
        self.inputStream = readStream!.takeRetainedValue()
        self.outputStream = writeStream!.takeRetainedValue()
        
        self.inputStream.delegate = self
        self.outputStream.delegate = self
        
        self.inputStream.schedule(in: RunLoop.current, forMode: RunLoopMode.defaultRunLoopMode)
        self.outputStream.schedule(in: RunLoop.current, forMode: RunLoopMode.defaultRunLoopMode)
        
        self.inputStream.open()
        self.outputStream.open()
    }
    
    func sendString (message: String){
        print("mess")
        print(message)
        let encodedDataArray = [UInt8](message.utf8)
        outputStream.write(encodedDataArray, maxLength: encodedDataArray.count)
    }
    
    func stream(_ handlestream: Stream, handle eventCode: Stream.Event) {
        print("stream event")
        switch (eventCode){
        case Stream.Event.errorOccurred:
            NSLog("ErrorOccurred")
            break
        case Stream.Event.endEncountered:
            NSLog("EndEncountered")
            break
            /*case Stream.Event.none:
             NSLog("None")
             break*/
        case Stream.Event.hasBytesAvailable:
            NSLog("HasBytesAvaible")
            var buffer = [UInt8](repeating: 0, count: 4096)
            if ( handlestream == inputStream){
                
                while (inputStream.hasBytesAvailable){
                    let len = inputStream.read(&buffer, maxLength: buffer.count)
                    if(len > 0){
                        let output = NSString(bytes: &buffer, length: buffer.count, encoding: String.Encoding.utf8.rawValue)
                        if (output != ""){
                            NSLog("server said: %@", output!)
                            let outputFirst = output?.substring(with: NSRange(location: 0, length: 1))
                            if (outputFirst == "1" && signUpAttempt!){
                                let mapViewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "TindFilm") as? TindFilm
                                self.navigationController?.pushViewController(mapViewControllerObj!, animated: true)

                            }
                        }
                    }
                }
            }
            break
            /*case Stream.Event.allZeros:
             NSLog("allZeros")
             break*/
        case Stream.Event.openCompleted:
            NSLog("OpenCompleted")
            break
        case Stream.Event.hasSpaceAvailable:
            NSLog("HasSpaceAvailable")
            break
        default:
            break
        }
        
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
        let messageString = "90;" + username! + ";" + password! + ";0;"
        print(messageString)
        sendString(message: messageString)
        signUpAttempt = true
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
