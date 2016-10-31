//
//  HomeSofa.swift
//  Sofa
//
//  Created by Robin Lietar on 31/10/2016.
//  Copyright © 2016 Sofa. All rights reserved.
//

import Foundation
import UIKit
import FBSDKLoginKit

class HomeSofa: UIViewController {
    
    @IBOutlet weak var createSofa: UIButton!
    
    @IBOutlet weak var joinSofa: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createSofa.imageView?.contentMode = .scaleAspectFit
        joinSofa.imageView?.contentMode = .scaleAspectFit
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.navigationController?.setToolbarHidden(false, animated: true)
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
}
