//
//  PeopleListViewController.swift
//  RdioParty
//
//  Created by Gabe Kangas on 2/22/15.
//  Copyright (c) 2015 Rdio. All rights reserved.
//

import UIKit

class PeopleListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var room :Room = Session.sharedInstance.room
    var firebaseRef :Firebase!

    @IBOutlet weak var peopleTableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarItem.title = "People"
        self.peopleTableview.contentInset = UIEdgeInsetsMake(60.0, 0.0, 0.0, 0.0)
        self.peopleTableview.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.firebaseRef = Firebase(url:"https://rdioparty.firebaseio.com/\(self.room.name)/people")

        load()
        setOnline()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
        cell.textLabel!.text = person.name
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
    
    func setOnline() {
        let postRef = self.firebaseRef.childByAppendingPath("/people/" + Session.sharedInstance.user.rdioId + "/isOnline")
        let isOnline = true
        postRef.setValue(isOnline)
    }

}
