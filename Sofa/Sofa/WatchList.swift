//
//  WatchList.swift
//  Sofa
//
//  Created by Robin Lietar on 31/10/2016.
//  Copyright © 2016 Sofa. All rights reserved.
//

import Foundation
import UIKit
import FBSDKLoginKit
import SDWebImage

class WatchList: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    public var user:User!
    var nc:NetworkCommunication!
    
    let notificationName = Notification.Name("WatchList.ConnexionSucceeded")
    let notificationName2 = Notification.Name("WatchList.ConnexionFailed")
    var filmWatchingListArr : [Dictionary<String, String>] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

        //initNetwork()
        nc = NetworkCommunication()
        nc.currentVC = "WatchList"
        
        //self.tableView.register(UINib(nibName: "CustomCell", bundle: nil), forCellReuseIdentifier: "cell")
        
        self.tableView.register(CustomCell.self, forCellReuseIdentifier: "cell")
        
        connexionAttempt()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    func connexionAttempt(){
        var messageString = "160;" + user.username! + ";"
        messageString = messageString + user.pwd! + ";1;1000;"
        print(messageString)
        nc.sendString(message: messageString)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(WatchList.connexionSucceeded), name: notificationName, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(WatchList.connexionFailed), name: notificationName2, object: nil)
    }
    
    func connexionSucceeded() {
        
        
        NotificationCenter.default.removeObserver(self, name: notificationName, object: nil);
        NotificationCenter.default.removeObserver(self, name: notificationName2, object: nil);
        
        parseOutput()
    }
    
    func connexionFailed() {
        print("connexion failed")
        NotificationCenter.default.removeObserver(self, name: notificationName, object: nil);
        NotificationCenter.default.removeObserver(self, name: notificationName2, object: nil);
    }
    
    func parseOutput() {
        let start = nc.outputRead.index(nc.outputRead.startIndex, offsetBy: 7)
        let end = nc.outputRead.index(nc.outputRead.endIndex, offsetBy: -2)
        let range = start..<end
        
        let realOutput = nc.outputRead.substring(with: range)
        
        let filmArr = realOutput.components(separatedBy: ")-(")
        for film in filmArr {
            var emptyDictionary = [String: String]()
            let divArr = film.components(separatedBy: ";")
            emptyDictionary["filmId"] = divArr[0]
            emptyDictionary["filmTitle"] = divArr[1]
            emptyDictionary["filmAffiche"] = divArr[2]
            emptyDictionary["filmRating"] = divArr[3]
            filmWatchingListArr.append(emptyDictionary)
        }
        print(filmWatchingListArr)
        tableView.reloadData()
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filmWatchingListArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:CustomCell = self.tableView.dequeueReusableCell(withIdentifier: "cell")! as! CustomCell
        var dic = filmWatchingListArr[indexPath.row]
        print(dic)
        print(dic["filmTitle"]! as String)
        cell.titleCell?.text = dic["filmTitle"]! as String
        cell.ratingCell?.text = "Rating: " + dic["filmTitle"]! + "/10"
        return cell
    
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "segueHomeSofa") {

            let destinationVC:HomeSofa = segue.destination as! HomeSofa
            
            //set properties on the destination view controller
            destinationVC.user = user
            //etc...
        }
    }
    
    
}
