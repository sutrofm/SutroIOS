//
//  RoomsViewController.swift
//  RdioParty
//
//  Created by Gabe Kangas on 2/22/15.
//

import UIKit

class RoomListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var roomsTableView: UITableView!
    var hud :RPHud!
    var rooms = Array<Room>()
    let firebaseref = Firebase(url:"https://rdioparty.firebaseio.com/")

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.navigationItem.hidesBackButton = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = ""
        load()
        showWaiting()
        setTitle()
    }
    
    override func viewWillAppear(animated: Bool) {
        setTitle()
    }
    
    override func viewDidAppear(animated: Bool) {
        UIApplication.rdioPartyApp.session.room = nil
    }
    
    func setTitle() {
        if let navbar = UIApplication.rdioPartyApp.navigationBar {
            navbar.setTitle("Parties")
        }
    }
    
    func load() {
        firebaseref.observeEventType(.ChildAdded, withBlock: { snapshot in
            if (snapshot.key != nil) {
                let room = Room(fromSnapshot: snapshot)
                
                if (room.previewPeopleCount > 0) {
                    self.updateData(room)
                }
            }
        })

    }
    
    func updateData(data :NSObject) {
        let newRoom = data as! Room
        self.rooms.append(newRoom)
        
        // Re-sort and display
        sortRooms()
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
        let room = self.rooms[indexPath.row]
        UIApplication.rdioPartyApp.session.room = room
        
        let vc: ApplicationTabBarController = self.storyboard?.instantiateViewControllerWithIdentifier("TabAppController") as! ApplicationTabBarController
        UIApplication.rdioPartyApp.tabBarController = vc // Keep a reference handy in our app delegate so we can tweak it
        self.navigationController!.pushViewController(vc, animated: true)
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    // MARK: - Table datasource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.rooms.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! RoomListTableViewCell
        let room = self.rooms[indexPath.row]
        let name = room.humanName
        cell.previewImage.sd_setImageWithURL(room.previewImage)
        cell.nameLabel.text = name
        cell.themeLabel.text = room.theme
        cell.userCountLabel.text = String(room.previewPeopleCount)
        
        // Alternate colors between rows
        var color :UIColor!
        if !room.active {
            color = UIColor.darkGrayColor()
        } else if (indexPath.row % 2 == 0) {
            color = UIColor.blueColor()
            cell.userCountLabel.textColor = UIColor.whiteColor()
        } else {
            color = UIColor.yellowColor()
            cell.userCountLabel.textColor = UIColor.blackColor()
        }
        cell.colorShield.backgroundColor = color
        cell.userCountLabel.backgroundColor = color
        
        return cell
    }
    
    func showWaiting() {
        hud = RPHud(style: JGProgressHUDStyle.Dark)
        hud.textLabel.text = "Finding parties..."
        hud.showInView(self.view, animated: true)
    }
    
    func hideWaiting() {
        if (hud != nil) {
            hud.dismiss()
        }
    }
    
    // Sort by user count and activity
    func sortRooms() {
        self.rooms = self.rooms.sort({
            if $0.active == $1.active {
                return $0.previewPeopleCount > $1.previewPeopleCount
            } else {
                return $0.active
            }
        })
    }
}
