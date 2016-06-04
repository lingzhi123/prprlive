//
//  ContainerViewController.swift
// Streamini
//
//  Created by Vasily Evreinov on 11/08/15.
//  Copyright (c) 2015 UniProgy s.r.o. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {
    let kSegueIdentifierMain    = "embedMain"
    let kSegueIdentifierPeople  = "embedPeople"
    var currentSegueIdentifier  = "embedMain"
    
    var parentController: RootViewController?

    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.performSegueWithIdentifier(kSegueIdentifierMain, sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let sid = segue.identifier {
            let destinationController = segue.destinationViewController 
            
            if sid == kSegueIdentifierMain {
                (destinationController as! MainViewController).rootControllerDelegate = parentController!
                parentController!.delegate = (destinationController as! MainViewController)
                
                if self.childViewControllers.count > 0 {
                    swapFromViewController(childViewControllers[0] , toViewController: destinationController)
                } else {
                    self.addChildViewController(destinationController)
                    destinationController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
                    self.view.addSubview(destinationController.view)
                    segue.destinationViewController.didMoveToParentViewController(self)
                }
            } else if segue.identifier == kSegueIdentifierPeople {
                self.swapFromViewController(childViewControllers[0] , toViewController: destinationController)

            }
        }
    }
    
    // MARK: - Helpers
    
    func swapFromViewController(fromViewController: UIViewController, toViewController: UIViewController) {
        toViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
        fromViewController.willMoveToParentViewController(nil)
        self.addChildViewController(toViewController)
        self.transitionFromViewController(fromViewController, toViewController: toViewController, duration: NSTimeInterval(1.0), options: UIViewAnimationOptions.TransitionNone, animations: nil) { (finished) -> Void in
            fromViewController.removeFromParentViewController()
            toViewController.didMoveToParentViewController(self)
        }
    }
    
    func swapViewControllers() {
        self.currentSegueIdentifier = (self.currentSegueIdentifier == kSegueIdentifierMain) ? kSegueIdentifierPeople : kSegueIdentifierMain
        self.performSegueWithIdentifier(currentSegueIdentifier, sender: nil)
    }
    
    func mainViewController() {
        if currentSegueIdentifier == kSegueIdentifierPeople {
            swapViewControllers()
        }
    }
    
    func peopleViewController() {
        if currentSegueIdentifier == kSegueIdentifierMain {
            swapViewControllers()
        }
    }
    
    // MARK: - Memmory management

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
