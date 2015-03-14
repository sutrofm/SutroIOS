//
//  PeopleListViewController.swift
//  RdioParty
//
//  Created by Gabe Kangas on 2/22/15.
//  Copyright (c) 2015 Rdio. All rights reserved.
//

import UIKit

class PeopleListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var room :Room = UIApplication.rdioPartyApp.session.room
    var firebaseRef :Firebase!
    var backgroundImage = RPParallaxImageView(image: nil)

    @IBOutlet weak var peopleTableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarItem.title = "People"
        self.peopleTableview.contentInset = UIEdgeInsetsMake(60.0, 0.0, 0.0, 0.0)
        self.peopleTableview.registerNib(UINib(nibName: "PersonListTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        self.firebaseRef = Firebase(url:"https://rdioparty.firebaseio.com/\(self.room.name)/people")

        self.peopleTableview.backgroundColor = UIColor.clearColor()
        self.peopleTableview.separatorColor = UIColor.clearColor()
        
        self.backgroundImage.frame = self.view.frame
        self.view.insertSubview(self.backgroundImage, belowSubview: self.peopleTableview)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "currentSongChanged", name: "currentSongChanged", object: nil)
        currentSongChanged()

        load()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func currentSongChanged() {
        if let song = UIApplication.rdioPartyApp.session.currentSong {
            
            var fadeDuration = 2.0
            if (self.backgroundImage.image == nil) {
                fadeDuration = 0
            }
            UIView.transitionWithView(self.backgroundImage, duration: fadeDuration, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: { () -> Void in
                self.backgroundImage.sd_setImageWithURL(song.backgroundImage)
            }, completion: nil)

        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Table delegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    // MARK: - Table datasource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.room.people.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let person = self.room.people[indexPath.row]
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! PersonListTableViewCell
        cell.textLabel!.text = person.name
        cell.imageView?.sd_setImageWithURL(NSURL(string:person.icon), placeholderImage: UIImage(named: "rdioPartyLogo.png"))
        cell.backgroundColor = UIColor.clearColor()
        cell.contentView.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.3)
        return cell
    }
    
    
    func load() {
        
        
        self.firebaseRef.observeEventType(.ChildAdded, withBlock: { snapshot in
            if (snapshot.value.valueForKey("id") != nil) {
                var person = Person(fromSnapshot: snapshot)
                if (person.isOnline && !self.room.hasUser(person.rdioId)) {
                    self.room.allPeople.append(person)
                    self.peopleTableview.reloadData()
                }
            }
        })
        
        self.firebaseRef.observeEventType(.ChildRemoved, withBlock: { snapshot in
            self.room.removeUser(snapshot)
        })
        
    }

}
