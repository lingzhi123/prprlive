//
//  LiveStreamViewController.swift
//  Streamini
//
//  Created by Vasily Evreinov on 29/06/15.
//  Copyright (c) 2015 Evghenii Todorov. All rights reserved.
//

import UIKit
import AVFoundation
import CoreLocation

class CreateStreamViewController: BaseViewController, UITextFieldDelegate, LocationManagerDelegate,
UITextViewDelegate {
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var darkPreviewView: UIView!
    @IBOutlet weak var nameTextView: UITextView!
    @IBOutlet weak var nameTextViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var connectingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var connectingLabel: UILabel!
    @IBOutlet weak var goLiveButtonBottom: NSLayoutConstraint! // 240
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var locationLabelWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var goLiveButton: UIButton!
    
    var stream: Stream?
    let camera = Camera()
    var keyboardHandler: CreateStreamKeyboardHandler?
    var textViewHandler: GrowingTextViewHandler?
    
    // MARK: - Actions
    
    @IBAction func liveStreamButtonPressed(sender: AnyObject) {
        var data = NSMutableDictionary(objects: [nameTextView.text], forKeys: ["title"])
        
        if let pm = LocationManager.shared.currentPlacemark {
            data["lon"]  = pm.location!.coordinate.longitude
            data["lat"]  = pm.location!.coordinate.latitude
            data["city"] = pm.locality
        }
        
        connectingIndicator.startAnimating()
        goLiveButton.hidden = true
        
//        if AmazonTool.isAmazonSupported() {
            StreamConnector().create(data, success: createStreamSuccess, failure: createStreamFailure)
//        } else {
//            let filename = "screenshot.jpg"
//            let screenshotData = UIImageJPEGRepresentation(camera.captureStillImage()!, 1.0)!
//            StreamConnector().createWithFile(filename, fileData: screenshotData, data: data, success: createStreamSuccess, failure: createStreamFailure)
//        }
    }
    
    @IBAction func closeButtonPressed(sender: AnyObject) {
        LocationManager.shared.stopMonitoringLocation()
        self.nameTextView.resignFirstResponder()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Network responses
    
    func createStreamSuccess(stream: Stream) {
        self.stream = stream
        
        LocationManager.shared.stopMonitoringLocation()
        
//        camera.start(stream.name, channelName: stream.channel)
        
//        if AmazonTool.isAmazonSupported() {
//            let screenshot = camera.captureStillImage()!
//            let filename = "\(UserContainer.shared.logged().id)-\(stream.id)-screenshot.jpg"
//            AmazonTool.shared.uploadImage(screenshot, name: filename)
//        }
//        
//        let twitter = SocialToolFactory.getSocial("Twitter")!
//        let url = "\(Config.shared.twitter().tweetURL)/\(stream.streamHash)/\(stream.id)"
//        twitter.post(UserContainer.shared.logged().name, live: NSURL(string: url)!)
//        
        self.performSegueWithIdentifier("CreateStreamToLiveStream", sender: self)        
    }
    
    func createStreamFailure(error: NSError) {
        handleError(error)
        connectingIndicator.stopAnimating()
        goLiveButton.hidden = false
    }
    
    // MARK: - LocationManagerDelegate
    
    func locationDidChanged(currentLocation: CLLocationCoordinate2D?, locality: String) {
        // Set location text
        locationLabel.text = locality
        
        // Set width constraint corresponds to the locality string lenght
        let size = locationLabel.sizeThatFits(locationLabel.bounds.size)
        locationLabelWidthConstraint.constant = size.width + 10
        locationLabel.backgroundColor = UIColor.whiteColor()
        self.view.layoutIfNeeded()
    }
    
    // MARK: - View life cycle 
    
    func configureView() {
        // Configure "go live" button
        let goLiveButtonText = NSLocalizedString("go_live_button", comment: "")
        goLiveButton.setTitle(goLiveButtonText, forState: UIControlState.Normal)
        
        // Configure NameTextView
        var nameTextViewFrame = nameTextView.frame
        nameTextViewFrame.size.height = 36.0
        nameTextView.frame = nameTextViewFrame
        
        // GrowingTextViewHandler resizes NameTextView according to input text
        self.textViewHandler = GrowingTextViewHandler(textView: nameTextView, withHeightConstraint: nameTextViewHeightConstraint)
        textViewHandler!.updateMinimumNumberOfLines(1, andMaximumNumberOfLine: 6)
        textViewHandler!.setText("", withAnimation: false)
        
        // Set placeholder for NameTextView
        nameTextView.tintColor = UIColor.whiteColor()
        let placeholderText = NSLocalizedString("stream_name_placeholder", comment: "")
        applyPlaceholderStyle(nameTextView, placeholderText: placeholderText)
        
        // Configure connecting label
        let connectingLabelText = NSLocalizedString("connecting_stream_label", comment: "")
        connectingLabel.text = connectingLabelText
        
        keyboardHandler = CreateStreamKeyboardHandler(view: view, constraint: goLiveButtonBottom)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        
        LocationManager.shared.delegate = self
        LocationManager.shared.startMonitoringLocation()
        
        nameTextView.becomeFirstResponder()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        keyboardHandler!.register()
        UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: .Fade)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        camera.setup(previewView)
        darkPreviewView.layer.addDarkGradientLayer()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        keyboardHandler!.unregister()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        connectingIndicator.stopAnimating()
        goLiveButton.hidden = false
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let sid = segue.identifier {
            if sid == "CreateStreamToLiveStream" {
                let controller = segue.destinationViewController as! LiveStreamViewController
//                controller.camera = camera
                controller.stream = stream
            }
        }
    }
    
    // MARK: - TextViewDelegate
    
    func moveCursorToStart(textView: UITextView)
    {
        dispatch_async(dispatch_get_main_queue(), {
            textView.selectedRange = NSMakeRange(0, 0);
        })
    }
    
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        if textView.textColor == UIColor(white: 1.0, alpha: 0.5)
        {
            // move cursor to start
            moveCursorToStart(textView)
        }
        return true
    }
    
    func textViewDidChange(textView: UITextView) {
        textView.text = textView.text.handleEmoji()
        self.textViewHandler!.resizeTextViewWithAnimation(true)        
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        var updatedText = (textView.text as NSString).stringByReplacingCharactersInRange(range, withString: text)
        updatedText = updatedText.handleEmoji()
        
        // Seach for new lines. Don't alow user to insert new lines in stream title
        let newLineRange: Range? = updatedText.rangeOfCharacterFromSet(NSCharacterSet.newlineCharacterSet())
        
        let shouldEdit = (updatedText.characters.count < 80) && (newLineRange == nil)
        if !shouldEdit {
            return false
        }
        
        if updatedText.isEmpty {
            let placeholderText = NSLocalizedString("stream_name_placeholder", comment: "")
            applyPlaceholderStyle(textView, placeholderText: placeholderText)
            moveCursorToStart(textView)
            return false
        }
        
        // Remove placeholder text if it is shown
        if nameTextView.textColor == UIColor(white: 1.0, alpha: 0.5) && !text.isEmpty {
            nameTextView.text = ""
            applyNonPlaceholderStyle(textView)
            return true
        }
        
        return true
    }
    
    func applyPlaceholderStyle(aTextview: UITextView, placeholderText: String)
    {
        // make it look (initially) like a placeholder
        aTextview.textColor = UIColor(white: 1.0, alpha: 0.5)
        aTextview.text = placeholderText
    }
    
    func applyNonPlaceholderStyle(aTextview: UITextView)
    {
        // make it look like normal text instead of a placeholder
        aTextview.textColor = UIColor.whiteColor()
        aTextview.alpha = 1.0
    }
    
    // MARK: - Memory management

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        camera.stop()
    }
    
}
