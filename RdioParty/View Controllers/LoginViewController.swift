//
//  LoginViewController.swift
//  RdioParty
//
//  Created by Gabe Kangas on 2/26/15.
//  Copyright (c) 2015 Rdio. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, RdioDelegate {

    var rdio = Rdio(clientId: Credentials.RdioConsumerKey, andSecret: Credentials.RdioConsumerSecret, delegate: nil);
    var firebaseRef :Firebase = Firebase(url:"https://rdioparty.firebaseio.com/")
    var hud :RPHud!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.rdio.delegate = self
        checkLogin()
        self.navigationController?.setNavigationBarHidden(true, animated: false)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateThemeColor", name: "themeColorChanged", object: nil)

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
        showWaitingIndicator()
        rdio.authorizeFromController(self)
    }
    
    func checkLogin() {
        let defaults = NSUserDefaults.standardUserDefaults()
        if let accesstoken = defaults.stringForKey("rdioAccessToken") {
            rdio.authorizeUsingAccessToken(accesstoken)
            showWaitingIndicator()
        }
    }
    
    func updateThemeColor() {
        self.navigationController?.navigationBar.tintColor = UIApplication.rdioPartyApp.session.themeColor
    }
    
    // MARK: - RdioDelegate
    
    func rdioDidAuthorizeUser(user: [NSObject : AnyObject]!, withAccessToken accessToken: String!) {
        let userKey: String? = user["key"] as? String
        
        UIApplication.rdioPartyApp.session.user = Person(fromRdioUser: user)
        UIApplication.rdioPartyApp.session.accessToken = accessToken
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(accessToken, forKey: "rdioAccessToken")
        defaults.synchronize()
        
        var roomList = self.storyboard!.instantiateViewControllerWithIdentifier("RoomListViewController") as! RoomListViewController
        self.navigationController?.pushViewController(roomList, animated: false)
        getFirebaseAuthToken(userKey!)
        hideWaitingIndicator()
    }
    
    func rdioAuthorizationFailed(error: NSError!) {
        hideWaitingIndicator()
        println("Rdio authorization failed with error: \(error.localizedDescription)")
        hud = RPHud(style: JGProgressHUDStyle.Dark)
        hud.textLabel.text = "Login has failed. " + error.localizedDescription
        hud.showInView(self.view, animated: false)
        hud.dismissAfterDelay(3, animated: true)
    }
    
    func rdioAuthorizationCancelled() {
        hideWaitingIndicator()
        println("rdioAuthorizationCancelled")
    }
    
    func getFirebaseAuthToken(rdioUserKey :String) {
        let manager = AFHTTPRequestOperationManager()
        let parameters = NSDictionary(object: rdioUserKey, forKey: "userKey")
        manager.GET("http://rdioparty.com/create-auth/",
            parameters: parameters,
            success: { (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in
                let token: String? = responseObject.valueForKey("token") as? String
                UIApplication.rdioPartyApp.session.firebaseAuthToken = token!
            },
            failure: { (operation: AFHTTPRequestOperation!, error: NSError!) in
            }
        )
    }

    func showWaitingIndicator() {
        hud = RPHud(style: JGProgressHUDStyle.Dark)
        hud.textLabel.text = "Logging in..."
        hud.showInView(self.view, animated: true)
    }
    
    func hideWaitingIndicator() {
        if (hud != nil) {
            hud.dismissAnimated(true)
        }
    }
}
