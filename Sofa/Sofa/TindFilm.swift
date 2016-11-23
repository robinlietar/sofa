//
//  TindFilm.swift
//  Sofa
//
//  Created by Robin Lietar on 31/10/2016.
//  Copyright © 2016 Sofa. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

class TindFilm: UIViewController, UIGestureRecognizerDelegate {
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var unlikeButton: UIButton!
    @IBOutlet weak var afficheFilm: UIImageView!
    @IBOutlet weak var backAfficheFilm: UIImageView!
    
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var synopsisTextView: UITextView!
    @IBOutlet weak var starringLabel: UILabel!
    @IBOutlet weak var directorLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    
    
    var cpt:Int!
    var afficheImages: [UIImage] = []
    var nc:NetworkCommunication!
    var infoFilmArr:[String]!
    var currentFilm:String!
    var likeFilmArr:[Int]!

    var infoHidden:Bool!
    
    public var user:User!


    override func viewDidLoad() {
        super.viewDidLoad()
        // Initializing variables
        infoHidden = true
        likeFilmArr = []
        
        likeButton.imageView?.contentMode = .scaleAspectFit
        unlikeButton.imageView?.contentMode = .scaleAspectFit
        cpt = 0
        afficheImages.append(UIImage(named: "SpiderMan_affiche.jpg")!)
        afficheImages.append(UIImage(named: "arnacoeur.jpg")!)
        afficheImages.append(UIImage(named: "chihiro.jpg")!)
        afficheImages.append(UIImage(named: "the-green-line.jpg")!)
        afficheImages.append(UIImage(named: "Juste-la-fin-du-monde.jpg")!)
        
        //self.afficheFilm.image = afficheImages[cpt]
        //self.backAfficheFilm.image = afficheImages[cpt + 1]
        
        
        print(user.affArrReco[0])
        
        self.afficheFilm.image = user.firstImage
        self.backAfficheFilm.image = user.secondImage
        let manager = SDWebImageManager()
        manager.downloadImage(with: NSURL(string: user.affArrReco[cpt + 2]) as URL!, options: SDWebImageOptions(rawValue: 0), progress: nil, completed: { (image, error, bool, cache, url) in
            print("image  2")
            if (image != nil) {
                print("image not nil")
                self.user.thirdImage = image
            }
            else {
                print("fail")
                self.user.thirdImage = self.user.secondImage
            }
        })

        
        //initNetwork()
        nc = NetworkCommunication()
        nc.currentVC = "TindFilm"
        
        // Init Tap gesture
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tap.delegate = self
        self.view.addGestureRecognizer(tap)
        
        
        currentFilm = user.idArrReco[cpt]
        getFilmInfos(_fid: currentFilm)
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
    
    @IBAction func unlikeSent(_ sender: AnyObject) {
        likeFilmArr.append(0)
        let finalPoint = CGPoint(x:-self.view.bounds.size.width/2,
                                 y:afficheFilm.center.y /*+ (velocity.y * slideFactor)*/)
        if (cpt < 9){
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
                self.likeButton.alpha = 1
                self.increment()

        })
        }
        else {
            self.increment()
        }
    }
    @IBAction func likeSent(_ sender: AnyObject) {
        likeFilmArr.append(1)

        let finalPoint = CGPoint(x:3*self.view.bounds.size.width/2,
                                 y:afficheFilm.center.y /*+ (velocity.y * slideFactor)*/)
        if (cpt < 9){
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
                self.unlikeButton.alpha = 1
                self.increment()

                
        })
    }
    else {
    self.increment()
    }
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
            if (cpt < 9 || !transition){
            UIView.animate(withDuration: 0.5,
                                       delay: 0,
                                       // 6
                options: UIViewAnimationOptions.curveEaseOut,
                animations: {
                    recognizer.view!.center = finalPoint
                    if (transition){
                        if (like){
                            self.likeFilmArr.append(1)
                            self.unlikeButton.alpha = 0
                        }
                        else {
                            self.likeFilmArr.append(0)
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
                        self.increment()
                    }
                    self.unlikeButton.alpha = 1
                    self.likeButton.alpha = 1
            })
        }
            else {
                self.increment()
            }
    }

    
    }
    
    func increment() {
        self.cpt = self.cpt + 1
        if (self.cpt == 10){
            sendLikeArray()
            let mapViewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "HomeSofa") as? HomeSofa
            mapViewControllerObj?.user = user
            self.navigationController?.pushViewController(mapViewControllerObj!, animated: true)
        }
        else if (self.cpt == 9){
            currentFilm = user.idArrReco[cpt]
            self.user.firstImage = self.user.secondImage
            self.afficheFilm.image = user.firstImage
            self.backAfficheFilm.isHidden = true
            getFilmInfos(_fid: currentFilm)
        }
        else {
            currentFilm = user.idArrReco[cpt]
            self.user.firstImage = self.user.secondImage
            self.user.secondImage = self.user.thirdImage
            self.afficheFilm.image = user.firstImage
            self.backAfficheFilm.image = user.secondImage
            getFilmInfos(_fid: currentFilm)
            if (self.cpt <= 7){
            let manager = SDWebImageManager()
            manager.downloadImage(with: NSURL(string: user.affArrReco[cpt + 2]) as URL!, options: SDWebImageOptions(rawValue: 0), progress: nil, completed: { (image, error, bool, cache, url) in
                print("image  2")
                if (image != nil) {
                    print("image not nil")
                    self.user.thirdImage = image
                }
                else {
                    print("fail")
                    self.user.thirdImage = self.user.secondImage
                }
            })
            }

        }
    }
    
    func sendLikeArray(){
        var ids:String = user.idArrReco[0]
        var cpt:Int = 0
        for i in user.idArrReco{
            if (cpt>=1){
                ids = ids + "::" + i
            }
            cpt = cpt + 1
        }
        var ch:String = String(likeFilmArr[0])
        var cpt2:Int = 0
        for i in likeFilmArr{
            if (cpt2>=1){
                ch = ch + "::" + String(i)
            }
            cpt2 = cpt2 + 1
        }
        let messageString = "92;" + user.username! + ";" + user.pwd! + ";" + ids + ";" + ch + ";"
        print(messageString)
        nc.sendString(message: messageString)
    }
    
    func handleTap() {
        infoHidden = !infoHidden
        self.infoView.isHidden = infoHidden
        
        
    }
    func getFilmInfos(_fid:String) {
        let messageString = "170;" + _fid + ";"
        print(messageString)
        nc.sendString(message: messageString)
        
        let notificationName = Notification.Name(nc.currentVC)
        NotificationCenter.default.addObserver(self, selector: #selector(TindFilm.parseFilmInfos), name: notificationName, object: nil)
    }
    func parseFilmInfos() {
        let notificationName = Notification.Name(nc.currentVC)
        NotificationCenter.default.removeObserver(self, name: notificationName, object: nil);
        let filmTmpArr = nc.outputRead.components(separatedBy: ";")
        infoFilmArr = []
        for str in filmTmpArr {
            let filmTmpArr2 = str.components(separatedBy: "::")
            let secondString:String = filmTmpArr2[1]
            infoFilmArr.append(secondString)
            //do something with currency
        }
        //infoFilmArr = nc.outputRead.components(separatedBy: ";")
        
        // Title
        titleLabel.text = infoFilmArr[2]
        
        // Year and length
        let sub:String = infoFilmArr[6] + " - " + infoFilmArr[7] + " mins"
        subTitleLabel.text = sub
        
        // Genres
        var genresString:String = infoFilmArr[1]
        genresString = genresString.replacingOccurrences(of: "[", with: "")
        genresString = genresString.replacingOccurrences(of: "]", with: "")
        genresString = genresString.replacingOccurrences(of: "'", with: "")
        genreLabel.text = genresString
        
        // Synopsis
        synopsisTextView.text = "  " + infoFilmArr[9]
        
        // Note
        noteLabel.text = infoFilmArr[0] + "/10"
        
        // Actors
        var actorString:String = infoFilmArr[5]
        actorString = actorString.replacingOccurrences(of: "[", with: "")
        actorString = actorString.replacingOccurrences(of: "]", with: "")
        let actTmpArr = actorString.components(separatedBy: ",")
        var cpt:Int = 0
        for act in actTmpArr {
            let index = act.index(act.startIndex, offsetBy: act.characters.count - 1)
            var act2 = act.substring(to: index)
            if (cpt == 0){
                let index2 = act2.index(act2.startIndex, offsetBy: 2)
                act2 = act2.substring(from: index2)
                actorString = "Starring: " + act2
            }
            else {
                let index2 = act2.index(act2.startIndex, offsetBy: 3)
                act2 = act2.substring(from: index2)
                actorString = actorString + ", " + act2
            }
            cpt = cpt + 1
        }
        starringLabel.text = actorString
        
        // Directors
        var dirString:String = infoFilmArr[4]
        dirString = dirString.replacingOccurrences(of: "[", with: "")
        dirString = dirString.replacingOccurrences(of: "]", with: "")
        let dirTmpArr = dirString.components(separatedBy: ",")
        var cpt2:Int = 0
        for dir in dirTmpArr {
            let index = dir.index(dir.startIndex, offsetBy: dir.characters.count - 1)
            var dir2 = dir.substring(to: index)
            if (cpt2 == 0){
                let index2 = dir2.index(dir2.startIndex, offsetBy: 2)
                dir2 = dir2.substring(from: index2)
                dirString = "Director: " + dir2
            }
            else {
                let index2 = dir2.index(dir2.startIndex, offsetBy: 3)
                dir2 = dir2.substring(from: index2)
                dirString = dirString + ", " + dir2
            }
            cpt2 = cpt2 + 1
        }
        directorLabel.text = dirString
    }
    
}
