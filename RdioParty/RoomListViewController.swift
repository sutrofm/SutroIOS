//
//  RoomsViewController.swift
//  RdioParty
//
//  Created by Gabe Kangas on 2/22/15.
//  Copyright (c) 2015 Rdio. All rights reserved.
//

import UIKit

class RoomListViewController: RdioPartyViewController, UITableViewDelegate, UITableViewDataSource {

    var presenter :Presenter!
    @IBOutlet weak var roomsTableView: UITableView!
    var rooms = Array<Room>()
    
    required override init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.presenter = RoomListPresenter(viewController: self)
        self.navigationItem.hidesBackButton = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Rooms"
        
        showWaiting();
    }
    
    override func updateData(data :NSObject) {
        let newRoom = data as! Room
        self.rooms.append(newRoom)
        self.roomsTableView.reloadData()
        hideWaiting()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addRoomButtonPressed(sender: AnyObject) {
    }

    // MARK: - Table delegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var room = self.rooms[indexPath.row]
        Session.sharedInstance.room = room
        
        let vc: UIViewController = self.storyboard?.instantiateViewControllerWithIdentifier("TabAppController") as! UIViewController
        if let navController = self.navigationController {
            navController.pushViewController(vc, animated: true)
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    // MARK: - Table datasource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.rooms.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! RoomListTableViewCell
        var room = self.rooms[indexPath.row]
        var name = room.name.stringByReplacingOccurrencesOfString("_", withString: " ").capitalizedString
        cell.previewImage.sd_setImageWithURL(room.previewImage)
        cell.nameLabel.text = name
        cell.themeLabel.text = room.theme
        cell.userCountLabel.text = String(room.previewPeopleCount)
        
        // Alternate colors between rows
        var color :UIColor!
        if (indexPath.row % 2 == 0) {
            color = UIColor.blueColor()
        } else {
            color = UIColor.yellowColor()
        }
        cell.colorShield.backgroundColor = color
        cell.userCountLabel.backgroundColor = color
        
        return cell
    }
    
    func showWaiting() {
        
    }
    
    func hideWaiting() {
        
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
