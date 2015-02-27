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
    
    @IBOutlet weak var peopleTableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarItem.title = "People"
        self.peopleTableview.contentInset = UIEdgeInsetsMake(60.0, 0.0, 0.0, 0.0)
        self.peopleTableview.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")

        load()
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
        
        var ref = Firebase(url:"https://rdioparty.firebaseio.com/\(self.room.name)/people")
        
        ref.observeEventType(.ChildAdded, withBlock: { snapshot in
            if (snapshot.key != nil) {
                var person = Person(fromSnapshot: snapshot)
                if (person.isOnline && !self.room.hasUser(person.rdioId)) {
                    self.room.people.append(person)
                    self.peopleTableview.reloadData()
                }
            }
        })
        
        ref.observeEventType(.ChildRemoved, withBlock: { snapshot in
            self.room.removeUser(snapshot)
        })
    }

}
