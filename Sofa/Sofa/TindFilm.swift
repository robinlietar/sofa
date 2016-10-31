//
//  TindFilm.swift
//  Sofa
//
//  Created by Robin Lietar on 31/10/2016.
//  Copyright © 2016 Sofa. All rights reserved.
//

import Foundation
import UIKit

class TindFilm: UIViewController {
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var unlikeButton: UIButton!
    @IBOutlet weak var afficheFilm: UIImageView!
    @IBOutlet weak var backAfficheFilm: UIImageView!
    var cpt:Int!
    
    @IBAction func unlikeSent(_ sender: AnyObject) {
        let finalPoint = CGPoint(x:-self.view.bounds.size.width/2,
                                 y:afficheFilm.center.y /*+ (velocity.y * slideFactor)*/)
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       // 6
            options: UIViewAnimationOptions.curveEaseOut,
            animations: {
                self.afficheFilm.center = finalPoint
                self.likeButton.alpha = 0
                
            },
            completion: {
                (value: Bool) in
                self.afficheFilm.center.x = self.view.bounds.size.width/2
                let image: UIImage = UIImage(named: "Juste-la-fin-du-monde.jpg")!
                self.afficheFilm.image = image
                self.likeButton.alpha = 1
                self.increment()

        })
    }
    @IBAction func likeSent(_ sender: AnyObject) {
        let finalPoint = CGPoint(x:3*self.view.bounds.size.width/2,
                                 y:afficheFilm.center.y /*+ (velocity.y * slideFactor)*/)
        UIView.animate(withDuration: 0.5,
            delay: 0,
            // 6
            options: UIViewAnimationOptions.curveEaseOut,
            animations: {
                self.afficheFilm.center = finalPoint
                self.unlikeButton.alpha = 0
                
            },
            completion: {
                (value: Bool) in
                self.afficheFilm.center.x = self.view.bounds.size.width/2
                let image: UIImage = UIImage(named: "Juste-la-fin-du-monde.jpg")!
                self.afficheFilm.image = image
                self.unlikeButton.alpha = 1
                self.increment()

                
        })
    }
    
    @IBAction func handlePan(recognizer:UIPanGestureRecognizer) {
        // Pan Gesture recognizer
        var transition = true
        var like = false

        let translation = recognizer.translation(in: self.view)
        if let view = recognizer.view {
            view.center = CGPoint(x:view.center.x + translation.x,
                                  y:view.center.y)
            unlikeButton.alpha = min(1,max(0,1 - (view.center.x - view.frame.size.width/2)/view.frame.size.width));
            likeButton.alpha = min(1,max(0,1 - (-view.center.x + view.frame.size.width/2)/view.frame.size.width))

        }

        
        recognizer.setTranslation(CGPoint(x: 0,y :0), in: self.view)
        
        if recognizer.state == UIGestureRecognizerState.ended {
            // 1
            let velocity = recognizer.velocity(in: self.view)
            let magnitude = sqrt((velocity.x * velocity.x) /*+ (velocity.y * velocity.y)*/)
            let slideMultiplier = magnitude / 200
            //println("magnitude: \(magnitude), slideMultiplier: \(slideMultiplier)")
            
            // 2
            let slideFactor = 0.1 * slideMultiplier     //Increase for more of a slide
            // 3
            var finalPoint = CGPoint(x:recognizer.view!.center.x + (velocity.x * slideFactor),
                                     y:recognizer.view!.center.y /*+ (velocity.y * slideFactor)*/)
            // 4
            finalPoint.x = min(max(finalPoint.x, -self.view.bounds.size.width/2), self.view.bounds.size.width + self.view.bounds.size.width/2)
            finalPoint.y = min(max(finalPoint.y, 0), self.view.bounds.size.height)
            
            if (finalPoint.x < self.view.bounds.size.width/6){
                finalPoint.x = -self.view.bounds.size.width/2
            }
            else if (finalPoint.x > 5*self.view.bounds.size.width/6){
                finalPoint.x = 3*self.view.bounds.size.width/2
                like = true
            }
            else
            {
                finalPoint.x = self.view.bounds.size.width/2
                transition = false
            }
            
            // 5
            UIView.animate(withDuration: 0.5,
                                       delay: 0,
                                       // 6
                options: UIViewAnimationOptions.curveEaseOut,
                animations: {
                    recognizer.view!.center = finalPoint
                    if (transition){
                        if (like){
                            self.unlikeButton.alpha = 0
                        }
                        else {
                            self.likeButton.alpha = 0
                        }
                    }
                    else {
                        self.unlikeButton.alpha = 1
                        self.likeButton.alpha = 1

                    }

                },
                completion: {
                    (value: Bool) in
                    if (transition){
                        recognizer.view!.center.x = self.view.bounds.size.width/2
                        let image: UIImage = UIImage(named: "Juste-la-fin-du-monde.jpg")!
                        self.afficheFilm.image = image
                    }
                    self.unlikeButton.alpha = 1
                    self.likeButton.alpha = 1
                    self.increment()
            })
        }
        
    }
    
    func increment() {
        self.cpt = self.cpt + 1
        if (self.cpt == 5){
            let mapViewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "HomeSofa") as? HomeSofa
            self.navigationController?.pushViewController(mapViewControllerObj!, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        likeButton.imageView?.contentMode = .scaleAspectFit
        unlikeButton.imageView?.contentMode = .scaleAspectFit
        cpt = 0
        

        
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
