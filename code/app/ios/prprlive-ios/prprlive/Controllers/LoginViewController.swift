//
//  LoginViewController.swift
//  Streamini
//
//  Created by Vasily Evreinov on 22/06/15.
//  Copyright (c) 2015 UniProgy s.r.o. All rights reserved.
//

import UIKit
import TwitterKit


class LoginViewController: BaseViewController {
    @IBOutlet weak var loginButton: UIButton!

    func loginSuccess(session: String) {
        loginButton.enabled = true
        A0SimpleKeychain().setString(session, forKey: "PHPSESSID")
        self.performSegueWithIdentifier("LoginToMain", sender: self)
    }
    
    func loginFailure(error: NSError) {
        loginButton.enabled = true
    }
    
    @IBAction func loginButtonPressed(sender: AnyObject) {
//        loginButton.enabled = false
        
//        Twitter.sharedInstance().logInWithViewController(self, completion: { (session, error) -> Void in
//            if error != nil {
//                UIAlertView.notAuthorizedAlert(NSLocalizedString("login_twitter_error", comment: "")).show()
//                self.loginButton.enabled = true
//                return
//            }
//            self.loginWithTwitterSession(session!)
        //        })
        self.performSegueWithIdentifier("LoginToMain", sender: self)
    }
    
//    func loginWithTwitterSession(session: TWTRSession) {
//        let loginData       = NSMutableDictionary()
//        loginData["id"]     = session.userID
//        loginData["token"]  = session.authToken
//        loginData["secret"] = session.authTokenSecret
//        loginData["type"]   = "twitter"
//        
//        A0SimpleKeychain().setString(session.userID, forKey: "id")
//        A0SimpleKeychain().setString(session.authToken, forKey: "token")
//        A0SimpleKeychain().setString(session.authTokenSecret, forKey: "secret")
//        A0SimpleKeychain().setString("twitter", forKey: "type")
//        
//        if let deviceToken = (UIApplication.sharedApplication().delegate as! AppDelegate).deviceToken {
//            loginData["apn"] = deviceToken
//        } else {
//            loginData["apn"] = ""
//        }
//        
//        let connector = UserConnector()
//        connector.login(loginData, success: self.loginSuccess, failure: self.loginFailure)
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let loginButtonTitle = NSLocalizedString("login_with_twitter_button", comment: "")
        self.loginButton.setTitle(loginButtonTitle, forState: UIControlState.Normal)

//        if let session = A0SimpleKeychain().stringForKey("PHPSESSID") {
            let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("RootViewControllerId") 
            self.navigationController!.pushViewController(controller, animated: false)
//        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController!.setNavigationBarHidden(true, animated: false)
        UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: .None)
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

}
