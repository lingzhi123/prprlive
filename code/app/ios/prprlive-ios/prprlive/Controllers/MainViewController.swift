//
//  MainViewController.swift
//  Streamini
//
//  Created by Vasily Evreinov on 22/06/15.
//  Copyright (c) 2015 UniProgy s.r.o. All rights reserved.
//

import UIKit

protocol MainViewControllerDelegate: class {
    func streamListReload()
    func changeMode(isGlobal: Bool)
}

class MainViewController: BaseViewController, MainViewControllerDelegate, UserSelecting {
    @IBOutlet weak var tableView: UITableView!
    let dataSource  = StreamDataSource()
    weak var rootControllerDelegate: RootViewControllerDelegate?
    var isGlobal    = false
    var timer: NSTimer?
    
    // MARK: - Network responses
    
    func successStreams(streams: [Stream]) {
        self.tableView.pullToRefreshView.stopAnimating()
        
        dataSource.lives  = streams//live.sorted({ (stream1, stream2) -> Bool in stream1.id > stream2.id })
//        dataSource.recent = streams
        
        tableView.reloadData()
        
        if let delegate = rootControllerDelegate {
            delegate.modeDidChange(isGlobal)
        }
    }
    
    func failureStream(error: NSError) {
        handleError(error)
        self.tableView.pullToRefreshView.stopAnimating()
        self.navigationItem.rightBarButtonItem?.enabled = true
    }
    
    func successUser(user: User) {
        UserContainer.shared.setLogged(user)
    }
    
    func failureUser(error: NSError) {
        handleError(error)
    }
    
    // MARK: - MainViewControllerDelegate
    
    func streamListReload() {
        StreamDashboardConnector().streams("app", channel: "live", success: self.successStreams, failure: self.failureStream)
    }
    
    func changeMode(isGlobal: Bool) {
        self.isGlobal = isGlobal
        self.navigationItem.rightBarButtonItem?.enabled = false
        StreamDashboardConnector().streams("app", channel: "live", success: self.successStreams, failure: self.failureStream)
        
        if let delegate = rootControllerDelegate {
            delegate.modeDidChange(isGlobal)
        }
    }
    
    // MARK: - Update
    
    func reload(timer: NSTimer) {
        StreamDashboardConnector().streams("app", channel: "live", success: self.successStreams, failure: self.failureStream)
    }    
    
    // MARK: - View life cycle
    
    func configureView() {
        dataSource.userSelectedDelegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        
        self.isGlobal = NSUserDefaults.standardUserDefaults().boolForKey("isGlobalStreamsInMain")

        tableView.delegate   = dataSource
        tableView.dataSource = dataSource
        tableView.addPullToRefreshWithActionHandler { () -> Void in
            StreamDashboardConnector().streams("app", channel: "live", success: self.successStreams, failure: self.failureStream)
        }
        
        UserConnector().get(nil, success: successUser, failure: failureUser)
        changeMode(isGlobal)
        
        self.timer = NSTimer(timeInterval: NSTimeInterval(10.0), target: self, selector: "reload:", userInfo: nil, repeats: true)
        NSRunLoop.mainRunLoop().addTimer(timer!, forMode: NSRunLoopCommonModes)
        
        UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: .None)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        StreamDashboardConnector().streams("app", channel: "live", success: self.successStreams, failure: self.failureStream)
        if timer == nil {
            self.timer = NSTimer(timeInterval: NSTimeInterval(10.0), target: self, selector: "reload:", userInfo: nil, repeats: true)
            NSRunLoop.mainRunLoop().addTimer(timer!, forMode: NSRunLoopCommonModes)
        }
        UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: .None)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        timer!.invalidate()
        timer = nil
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let sid = segue.identifier {
            if sid == "MainToJoinStream" || sid == "MainRecentToJoinStream" {
                let navigationController = segue.destinationViewController as! UINavigationController
                let controller = navigationController.viewControllers[0] as! JoinStreamViewController
                controller.stream = (sender as! StreamCell).stream
                controller.isRecent = (sid == "MainRecentToJoinStream")
                controller.delegate = self
            }
        }
    }
    
    // MARK: - UserSelecting protocol
    
    func userDidSelected(user: User) {
        self.showUserInfo(user, userStatusDelegate: nil)
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
