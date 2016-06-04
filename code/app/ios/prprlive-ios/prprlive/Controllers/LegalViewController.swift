//
//  LegalViewController.swift
// Streamini
//
//  Created by Vasily Evreinov on 17/08/15.
//  Copyright (c) 2015 UniProgy s.r.o. All rights reserved.
//

import UIKit

enum LegalViewControllerType {
    case TermsOfService
    case PrivacyPolicy
}

class LegalViewController: BaseViewController, UIWebViewDelegate {
    @IBOutlet weak var webView: UIWebView!
    var type: LegalViewControllerType?
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let urlString: String
        switch type! {
        case .TermsOfService:
            urlString = Config.shared.legal().termsOfService
            self.title = NSLocalizedString("profile_terms", comment: "")
        case .PrivacyPolicy:
            urlString = Config.shared.legal().privacyPolicy
            self.title = NSLocalizedString("profile_privacy", comment: "")
        }
        
        let url = NSURL(string: urlString)!
        webView.loadRequest(NSURLRequest(URL: url))
        
        // Do any additional setup after loading the view.
    }
    
    // MARK: - UIWebViewDelegate
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if navigationType == UIWebViewNavigationType.LinkClicked {
            UIApplication.sharedApplication().openURL(request.URL!)
            return false
        }
        return true
    }
    
    // MARK: - Memory management
    
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
