//
//  SofaWaiting.swift
//  Sofa
//
//  Created by Robin Lietar on 19/11/2016.
//  Copyright © 2016 Sofa. All rights reserved.
//

import Foundation
import UIKit
import FBSDKLoginKit

class SofaWaiting: UIViewController {
    

    @IBAction func goSender(_ sender: Any) {
    }
    
    @IBAction func refreshSender(_ sender: Any) {
    }
    
    @IBOutlet weak var sofaLabel: UILabel!
    @IBOutlet weak var numberPeopleLabel: UILabel!
    
    public var user:User!
    public var sofaName:String?
    var nc:NetworkCommunication!
    let notificationName = Notification.Name("WaitingList.ConnexionSucceeded")
    let notificationName2 = Notification.Name("WaitingList.ConnexionFailed")
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Keyboard moving
        

        
        //initNetwork()
        nc = NetworkCommunication()
        nc.currentVC = "WaitingList"
        sofaLabel.text = "Sofa : " + sofaName!
        
        // Do any additional setup after loading the view, typically from a nib.
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
