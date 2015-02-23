//
//  PeopleListViewController.swift
//  RdioParty
//
//  Created by Gabe Kangas on 2/22/15.
//  Copyright (c) 2015 Rdio. All rights reserved.
//

import UIKit

class PeopleListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var peopleTableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarItem.title = "People"
        self.peopleTableview.contentInset = UIEdgeInsetsMake(60.0, 0.0, 0.0, 0.0)
        self.peopleTableview.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")

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
        return ConnectionManager.sharedInstance.room.people.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let person = ConnectionManager.sharedInstance.room.people[indexPath.row]
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
        cell.textLabel!.text = person.name
        return cell
    }

}
