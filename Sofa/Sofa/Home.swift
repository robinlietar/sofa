//
//  Home.swift
//  Sofa
//
//  Created by Robin Lietar on 30/10/2016.
//  Copyright © 2016 Sofa. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class Home: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if (FBSDKAccessToken.current() != nil)
        {
            // User is already logged in, do work such as go to next view controller.
        }
        else
        {
            
        }
        

        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

}

