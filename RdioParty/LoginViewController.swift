//
//  LoginViewController.swift
//  RdioParty
//
//  Created by Gabe Kangas on 2/26/15.
//  Copyright (c) 2015 Rdio. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, RdioDelegate {

    var rdio = Rdio(consumerKey: "mqbnqec7reb8x6zv5sbs5bq4", andSecret: "NTu8GRBzr5", delegate: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.rdio.delegate = self
        checkLogin()
        self.navigationController?.setNavigationBarHidden(true, animated: false)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    

    @IBAction func loginButtPressed(sender: AnyObject) {
        rdio.authorizeFromController(self)
    }
    
    func checkLogin() {
        let defaults = NSUserDefaults.standardUserDefaults()
        if let accesstoken = defaults.stringForKey("rdioAccesstoken") {
            rdio.authorizeUsingAccessToken(accesstoken);
        }
    }
    
    // MARK: - RdioDelegate
    
    func rdioDidAuthorizeUser(user: [NSObject : AnyObject]!, withAccessToken accessToken: String!) {
        Session.sharedInstance.user = user
        Session.sharedInstance.accessToken = accessToken
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(accessToken, forKey: "rdioAccessToken")
        defaults.synchronize()
        
        var roomList = self.storyboard!.instantiateViewControllerWithIdentifier("RoomListViewController") as! RoomListViewController
        self.navigationController?.pushViewController(roomList, animated: false)
    }
    
    func rdioAuthorizationFailed(error: NSError!) {
        println("Rdio authorization failed with error: \(error.localizedDescription)")
    }
    
    func rdioAuthorizationCancelled() {
        println("rdioAuthorizationCancelled")
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
