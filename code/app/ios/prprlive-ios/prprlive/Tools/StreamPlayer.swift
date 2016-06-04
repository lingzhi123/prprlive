//
//  StreamPlayer.swift
//  Streamini
//
//  Created by Vasily Evreinov on 14/07/15.
//  Copyright (c) 2015 UniProgy s.r.o. All rights reserved.
//

import UIKit
import libksygpulive
import MediaPlayer

protocol StreamPlayerDelegate {
}

class StreamPlayer: NSObject {
    var player: KSYMoviePlayerController?
    var url: NSURL?
    var reloadUrl: NSURL?
    
    var videoView: UIView?
    var timer: NSTimer?
    var view: UIView?
    var lastCheckTime: NSTimeInterval = 0.0
    var lastSize: Double = 0.0
    
    var stat: UILabel?
    var serverIp: NSString = ""
    
    var prepared_time: Int64 = 0
    var fvr_costtime: Int = 0
    var far_costtime: Int = 0
    
    var indicator: UIActivityIndicatorView?
    var isRecent = false
    var delegate: StreamPlayerDelegate?
    
    // MARK: - Initialization
    
    init(stream: Stream, isRecent: Bool, view: UIView, indicator: UIActivityIndicatorView) {
        super.init()
        self.view       = view
        self.indicator  = indicator
        self.isRecent   = isRecent
        
        self.url = streamURL(stream)
        self.reloadUrl = streamURL(stream)
//        self.player = AVPlayer(URL: url) as? AVPlayer
//        player!.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions(), context: nil)
        
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: "streamDidFinish:", name: AVPlayerItemDidPlayToEndTimeNotification, object: nil)        
        
//        playerLayer = AVPlayerLayer(player: player)
//        playerLayer!.videoGravity = AVLayerVideoGravityResizeAspectFill
//        playerLayer!.addObserver(self, forKeyPath: "readyForDisplay", options: NSKeyValueObservingOptions(), context: nil)
        
        //add UIView for player
        self.videoView = UIView()
        self.videoView!.backgroundColor = UIColor.whiteColor()
        self.view!.addSubview(videoView!)
        
        self.stat = UILabel()
        self.stat!.backgroundColor = UIColor.clearColor()
        self.stat!.textColor = UIColor.redColor()
        self.stat!.numberOfLines = -1;
        self.stat!.textAlignment = NSTextAlignment.Left
        self.view!.addSubview(stat!)
        
//        indicator.startAnimating()
        
        self.layoutUI()
        
        self.play()
        
//        var asError: NSError?
//        let audioSession = AVAudioSession.sharedInstance()
//        do {
//            try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord, withOptions:AVAudioSessionCategoryOptions.MixWithOthers)
//        } catch let error as NSError {
//            asError = error
//        }
//        do {
//            try audioSession.setMode(AVAudioSessionModeVideoRecording)
//        } catch let error as NSError {
//            asError = error
//        }
//        
//        do {
//            try audioSession.setActive(true, withOptions: AVAudioSessionSetActiveOptions.NotifyOthersOnDeactivation)
//        } catch let error as NSError {
//            asError = error
//        }
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: "playInterrupt:", name: AVAudioSessionInterruptionNotification, object: audioSession)
    }
    
    deinit {
        reset()
    }
    
    func reset() {
        self.stop()
        
//        if let p = player, pl = playerLayer {
//            NSNotificationCenter.defaultCenter().removeObserver(self)
//            
//            player!.removeObserver(self, forKeyPath: "status")
//            playerLayer!.removeObserver(self, forKeyPath: "readyForDisplay")
//            
//            player = nil
//            playerLayer!.player = nil
//            playerLayer = nil
//        }
    }
    
    func layoutUI() {
        let wdt: CGFloat = self.view!.bounds.size.width;
        let hgt: CGFloat = self.view!.bounds.size.height;
        let gap: CGFloat = 20;
        let btnWdt: CGFloat = ( (wdt-gap) / 5) - gap;
        let btnHgt: CGFloat = 30;
        var xPos: CGFloat = 0;
        var yPos: CGFloat = 0;
        
        yPos = gap;
        xPos = gap;
//        lableVPP.frame = CGRectMake(xPos, yPos, btnWdt * 2, btnHgt);
//        xPos = wdt/2 - btnWdt/2;
//        switchVPP.frame = CGRectMake(xPos, gap, btnWdt, btnHgt);
//        switchLog.frame = CGRectMake(xPos + btnWdt + 50, gap, btnWdt, btnHgt);
//        switchHwCodec.frame = CGRectMake(xPos, gap, btnWdt, btnHgt);
        
        self.videoView!.frame = CGRectMake(0, 0, wdt, hgt);
        xPos = gap;
        yPos = hgt - btnHgt - gap;
//        btnPlay.frame = CGRectMake(xPos, yPos, btnWdt, btnHgt);
//        xPos += gap + btnWdt;
//        btnPause.frame = CGRectMake(xPos, yPos, btnWdt, btnHgt);
//        xPos += gap + btnWdt;
//        btnReload.frame = CGRectMake(xPos, yPos, btnWdt, btnHgt);
//        xPos += gap + btnWdt;
//        btnStop.frame = CGRectMake(xPos, yPos, btnWdt, btnHgt);
//        xPos += gap + btnWdt;
//        btnQuit.frame = CGRectMake(xPos, yPos, btnWdt, btnHgt);
        self.stat!.frame = CGRectMake(gap, 0, wdt, hgt/2);
//        // top row 3 left
//        yPos += (gap + btnHgt);
//        xPos = gap;
//        getQosBtn.frame = CGRectMake(xPos, btnStop.frame.origin.y - 40, btnWdt, btnHgt);
        
    }
    
    func handlePlayerNotify(notify: NSNotification) {
        if ((self.player == nil)) {
            return
        }
        if (MPMediaPlaybackIsPreparedToPlayDidChangeNotification ==  notify.name) {
            stat!.text = NSString.pn_stringWithFormat("player prepared", argumentsArray: nil)
            // using autoPlay to start live stream
            //        [_player play];
            serverIp = (self.player?.serverAddress)!
            NSLog(String(format: "%@ -- ip:%@", self.url!, serverIp))
            self.StartTimer()
        }
        if (MPMoviePlayerPlaybackStateDidChangeNotification ==  notify.name) {
            NSLog("------------------------")
            NSLog(String("player playback state: %ld", self.player!.playbackState))
            NSLog("------------------------")
        }
        if (MPMoviePlayerLoadStateDidChangeNotification ==  notify.name) {
            NSLog(String("player load state: %ld", self.player!.loadState))
            if (MPMovieLoadState.Stalled == self.player!.loadState) {
                self.stat!.text = NSString.pn_stringWithFormat("player start caching", argumentsArray: nil)
                NSLog("player start caching")
            }
            MPMovieLoadState.Playable
            if ((self.player!.bufferEmptyCount != 0) &&
                (MPMovieLoadState.Playable == self.player!.loadState ||
                    MPMovieLoadState.PlaythroughOK == self.player!.loadState)){
                NSLog("player finish caching")
                let message: NSString = NSString.init(format: "loading occurs, %d - %0.3fs", self.player!.bufferEmptyCount, self.player!.bufferEmptyDuration)
                
                self.toast(message as String)
            }
        }
        if (MPMoviePlayerPlaybackDidFinishNotification ==  notify.name) {
            NSLog(String("player finish state: %ld", self.player!.playbackState))
            NSLog(String("player download flow size: %f MB", self.player!.readSize))
            NSLog(String("buffer monitor  result: \n   empty count: %d, lasting: %f seconds",
                   self.player!.bufferEmptyCount,
                   self.player!.bufferEmptyDuration))
            let reason: Int = notify.userInfo![MPMoviePlayerPlaybackDidFinishReasonUserInfoKey] as! Int
            if (reason == 0) {
                stat!.text = "player finish"
                
            }else if (reason == 1){
                stat!.text = "player Error"
                
            }else if (reason == 2){
                stat!.text = "player userExited"
                
            }
            self.StopTimer()
        }
        if (MPMovieNaturalSizeAvailableNotification ==  notify.name) {
            NSLog(String("video size %.0f-%.0f", self.player!.naturalSize.width, self.player!.naturalSize.height))
        }
        if (MPMoviePlayerFirstVideoFrameRenderedNotification == notify.name)
        {
            fvr_costtime = (Int64(self.getCurrentTime()) * 1000) - prepared_time
            NSLog(String(format: "first video frame show, cost time : %dms!\n", fvr_costtime))
        }
        
        if (MPMoviePlayerFirstAudioFrameRenderedNotification == notify.name)
        {
            far_costtime = (Int64(self.getCurrentTime()) * 1000) - prepared_time
            NSLog(String(format: "first audio frame render, cost time : %dms!\n", far_costtime))
        }
    }
    func setupObservers() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(StreamPlayer.handlePlayerNotify(_:)), name: (MPMediaPlaybackIsPreparedToPlayDidChangeNotification), object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(StreamPlayer.handlePlayerNotify(_:)), name: (MPMoviePlayerPlaybackStateDidChangeNotification), object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(StreamPlayer.handlePlayerNotify(_:)), name: (MPMoviePlayerPlaybackDidFinishNotification), object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(StreamPlayer.handlePlayerNotify(_:)), name: (MPMoviePlayerLoadStateDidChangeNotification), object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(StreamPlayer.handlePlayerNotify(_:)), name: (MPMovieNaturalSizeAvailableNotification), object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(StreamPlayer.handlePlayerNotify(_:)), name: (MPMoviePlayerFirstVideoFrameRenderedNotification), object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(StreamPlayer.handlePlayerNotify(_:)), name: (MPMoviePlayerFirstAudioFrameRenderedNotification), object: nil)
    }
    
    func releaseObservers() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: (MPMediaPlaybackIsPreparedToPlayDidChangeNotification), object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: (MPMoviePlayerPlaybackStateDidChangeNotification), object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: (MPMoviePlayerPlaybackDidFinishNotification), object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: (MPMoviePlayerLoadStateDidChangeNotification), object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: (MPMovieNaturalSizeAvailableNotification), object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: (MPMoviePlayerFirstVideoFrameRenderedNotification), object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: (MPMoviePlayerFirstAudioFrameRenderedNotification), object: nil)
    }
    
    // MARK: - Play/Stop methods
    
    func play() {
        
        if ((self.player) != nil) {
            self.player!.play()
            self.StartTimer()
            return;
        }
        self.player = KSYMoviePlayerController(contentURL: self.url)

        self.player!.logBlock = {(logJson: String!) -> Void in
            NSLog("logJson is %@",logJson)
        }

        self.stat!.text = String(format: "url %@", self.url!)
        self.player!.controlStyle = MPMovieControlStyle.None
        self.player!.view!.frame = self.videoView!.bounds  // player's frame must match parent's
        self.videoView!.addSubview(self.player!.view!)
        self.videoView!.bringSubviewToFront(self.stat!)
        self.videoView!.autoresizesSubviews = true
        self.player!.view!.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        self.player!.shouldAutoplay = true
        self.player!.bufferTimeMax = 5
        self.player!.shouldEnableVideoPostProcessing = true //switchVPP.on
        self.player!.scalingMode = MPMovieScalingMode.AspectFit
        self.player!.shouldUseHWCodec = false //switchHwCodec.isOn
        self.player!.shouldEnableKSYStatModule = true
        //[_player setTimeout:10];

        NSLog("sdk version:%@", self.player!.getVersion());
        prepared_time = (Int64)(self.getCurrentTime() * 1000);
        self.player!.prepareToPlay()
//        if (self.player!.status == AVPlayerStatus.ReadyToPlay) {
//            self.player!.seekToTime(CMTimeMake(0, player!.currentTime().timescale), completionHandler: { (finished) -> Void in
//                self.playerLayer!.videoGravity = AVLayerVideoGravityResizeAspect
//                self.player!.play()
//            })
//        }
    }
        
    func stop() {
//        if let p = player {
//            player!.pause()
//        }
        
        if (self.player != nil) {
//            NSLog(String("player download flow size: %f MB", self.player!.readSize))
//            NSLog(String("buffer monitor  result: \n   empty count: %d, lasting: %f seconds",
//                   self.player!.bufferEmptyCount,
//                   self.player!.bufferEmptyDuration))
            
            self.player!.stop()
            self.player!.view.removeFromSuperview()
            self.player = nil;
            self.stat?.text = NSString.pn_stringWithFormat("url: %@\nstopped", argumentsArray: [self.url!])
            self.StopTimer()
        }
    }
    
    // MARK: - Notifications and observers
    
//    func streamDidFinish(notification: NSNotification) {
//        playerLayer!.videoGravity = AVLayerVideoGravityResizeAspectFill
//        
//        if let del = delegate {
//            del.streamDidFinish()
//        }
//    }

    // MARK: - Observers 
    
//    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
//        if keyPath == "status" {
//            if (player!.status == AVPlayerStatus.ReadyToPlay) {
//                player!.play()
//            }
//        }
//        
//        if keyPath == "readyForDisplay" {
//            if playerLayer!.readyForDisplay {
//                indicator!.stopAnimating()
//                playerLayer!.frame = view!.frame
//                view!.layer.addSublayer(playerLayer!)
//                
//                if isRecent {
//                    player!.pause()
//                }
//                
//                if let del = self.delegate {
//                    del.streamDidLoad()
//                }
//            }
//        }
//    }
    
//    func playInterrupt(notification: NSNotification) {
//        
//        if notification.name == AVAudioSessionInterruptionNotification && notification.userInfo != nil {
//            var intValue: UInt = 0
//            (notification.userInfo![AVAudioSessionInterruptionTypeKey] as! NSValue).getValue(&intValue)
//            
//            if let type = AVAudioSessionInterruptionType(rawValue: intValue) {
//                
//                switch type {
//                    
//                case .Began:
//                    // interruption began
//                    // NOTE: the pause function saves play state
//                    self.player!.play()
//                    
//                case .Ended:
//                    // interruption ended
//                    self.player!.play()
//
//                }
//            }
//        }
//    }
    
    
    private func StartTimer() {
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target:self, selector:Selector("updateStat:"), userInfo:nil, repeats:true)
//    switchVPP.enabled = NO;
    }
    private func StopTimer() {
        if (nil == timer) {
            return;
        }
        timer!.invalidate()
        timer = nil
//    switchVPP.enabled = YES;
    }
    private func updateStat(t: NSTimer) {
        if ( 0 == lastCheckTime) {
            lastCheckTime = self.getCurrentTime()
            return;
        }
        if (nil == self.player) {
            return;
        }
//        var flowSize: Double = self.player!.readSize
//        NSLog("flowSize:%f", flowSize)
//        var meta: NSDictionary = self.player!.getMetadata()
//        stat.text = NSString.pn_stringWithFormat(
//            "SDK Version:v%@\n"+"%@\nip:%@ (w-h: %.0f-%.0f)\n"+"play time:%.1fs - %.1fs - %.1fs\n"+"cached time:%.1fs/%ld - %.1fs\n"+"speed: %0.1f kbps\nvideo/audio render cost time:%dms/%dms\n"+"HttpConnectTime:%@\n"+"HttpAnalyzeDns:%@\n"+"HttpFirstDataTime:%@\n",
//            argumentsArray: [self.player!.getVersion(), self.url, self.serverIP, self.player!.naturalSize.width, self.player!.naturalSize.height,
//                self.player!.currentPlaybackTime, self.player!.playableDuration, self.player!.duration,
//                self.player!.bufferEmptyDuration, self.player!.bufferEmptyCount, self.player!.bufferTimeMax,
//                8*1024.0*(flowSize - lastSize)/(self.getCurrentTime() - lastCheckTime),
//                fvr_costtime, far_costtime,
//                [meta.objectForKey:kKSYPLYHttpConnectTime],
//                [meta.objectForKey:kKSYPLYHttpAnalyzeDns],
//                [meta.objectForKey:kKSYPLYHttpFirstDataTime]])
//        lastCheckTime = [self getCurrentTime];
//        lastSize = flowSize;
    }
    private func getCurrentTime() -> NSTimeInterval {
        let date: NSDate = NSDate()
        return date.timeIntervalSince1970
    }
    
    private func toast(message: String?) {
        let toast: UIAlertView = UIAlertView(title: nil, message: message, delegate: nil, cancelButtonTitle: nil)
        toast.show()
        
        let duration: Float = 0.5; // duration in seconds
        toast.dismissWithClickedButtonIndex(0, animated: true)
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(duration * Float(NSEC_PER_SEC))), dispatch_get_main_queue(), {toast.dismissWithClickedButtonIndex(0, animated: true)
            });
    }

    // MARK: - Private methods
    
    private func streamURL(stream: Stream) -> NSURL {
        let url: String = "rtmp://test.live.ksyun.com/"+stream.channel+"/"+stream.name
        return NSURL(string: url)!
    }
}
