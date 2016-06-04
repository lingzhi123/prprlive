//
//  Camera.swift
//  Streamini
//
//  Created by Vasily Evreinov on 29/06/15.
//  Copyright (c) 2015 UniProgy s.r.o. All rights reserved.
//

import UIKit
import AVFoundation
import libksygpulive

class Camera {
    var liveStreamName: String?
//    var session: VCSimpleSession?
    var session: KSYStreamer?
    var image: UIImage?
    var previewView: UIView?

    func setup(view: UIView) {
        self.previewView = view
        
//        self.session = VCSimpleSession(videoSize: view.bounds.size, frameRate: 30, bitrate: 1000000, useInterfaceOrientation: false)
//        session!.orientationLocked = true
        
        self.session = KSYStreamer(defaultCfg: ())
        self.setStreamerCfg()
        
        addPreviewView(view)
//        session!.previewView.frame = view.bounds
    }
    
    func setStreamerCfg() {
        // capture settings
//        if (_btnHighRes.on ) {
//            _pubSession.videoDimension = KSYVideoDimension_16_9__960x540;
//        }
//        else {
//            _pubSession.videoDimension = KSYVideoDimension_16_9__640x360;
//        }
        self.session!.videoDimension = KSYVideoDimension._16_9__960x540
        
        self.session!.videoCodec = KSYVideoCodec.X264
        self.session!.videoFPS = 15;
        
        // stream settings
        self.session!.videoInitBitrate = 1000; // k bit ps
        self.session!.videoMaxBitrate  = 1000; // k bit ps
        self.session!.videoMinBitrate  = 100; // k bit ps
        self.session!.audiokBPS        = 48; // k bit ps
//        self.session!.enAutoApplyEstimateBW = _btnAutoBw.on;
        self.session!.enAutoApplyEstimateBW = true
        
        self.setVideoOrientation()
    }
    func setVideoOrientation() {
        let orien: UIDeviceOrientation = UIDevice.currentDevice().orientation
        switch (orien) {
        case UIDeviceOrientation.PortraitUpsideDown:
            self.session!.videoOrientation = AVCaptureVideoOrientation.PortraitUpsideDown;
            break;
        case UIDeviceOrientation.LandscapeLeft:
            self.session!.videoOrientation = AVCaptureVideoOrientation.LandscapeRight;
            break;
        case UIDeviceOrientation.LandscapeRight:
            self.session!.videoOrientation = AVCaptureVideoOrientation.LandscapeLeft;
            break;
        default:
            self.session!.videoOrientation = AVCaptureVideoOrientation.Portrait;
            break;
        }
    }
    
    func start(streamName: String, channelName: String) {
//        self.liveStreamName = streamName
        let url = self.getConnectionData(streamName, channelName: channelName)
//        session!.startRtmpSessionWithURL(url, andStreamKey: streamName)
        
        if (self.session!.captureState != KSYCaptureState.Capturing) {
            return;
        }
        if (self.session!.streamState != KSYStreamState.Connected) {
            self.session!.startStream(NSURL(string: url))
            NSLog("Start uplive stream : "+url)
//            [self initStatData];
        }
    }
    
    func stop() {
        if (self.session != nil) {
//            ses.endRtmpSession()
//            ses.previewView.removeFromSuperview()
            
            self.session!.stopStream()
            self.session!.stopPreview()
        }
        
        self.liveStreamName = nil
        
        session     = nil
        previewView = nil
    }
    
    func captureStillImage() -> UIImage? {
        if let view = previewView {
            UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0)
            view.drawViewHierarchyInRect(view.bounds, afterScreenUpdates: false)
            self.image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return self.image
        }
        return nil
    }
    
    func addPreviewView(view: UIView) {
//        view.addSubview(session!.previewView)
        if ( self.session!.captureState == KSYCaptureState.Capturing ) {
            self.session!.stopPreview()
            UIApplication.sharedApplication().idleTimerDisabled = false
        }
        self.setStreamerCfg()
        self.session!.startPreview(view)
        UIApplication.sharedApplication().idleTimerDisabled = true
    }
    
    func switchCameraDirection() {
//        session!.cameraState = (session!.cameraState == VCCameraState.Back) ? VCCameraState.Front : VCCameraState.Back
        
        if ( self.session!.switchCamera() == false) {
            NSLog("切换失败 当前采集参数 目标设备无法支持");
        }
//        var backCam: Bool = (self.session!.cameraPosition == AVCaptureDevicePosition.Back);
//        if ( backCam ) {
//            [_btnCamera setTitle:@"切到前摄像" forState: UIControlStateNormal];
//        }
//        else {
//            [_btnCamera setTitle:@"切到后摄像" forState: UIControlStateNormal];
//        }
//        backCam = backCam && (_pubSession.captureState == KSYCaptureStateCapturing);
//        [_btnFlash  setEnabled:backCam ];
    }
    
    // MAKR: - Private methods
    
    private func getConnectionData(streamName: String, channelName: String) -> String {
//        let (host, port, application, username, password) = Config.shared.wowza()
//        let url = "rtmp://\(username):\(password)@\(host):\(port)/\(application)"
//        let streamName = "\(hash)-\(streamId)"
        let url = "rtmp://test.uplive.ksyun.com/\(channelName)/\(streamName)"
        return url
    }
    
}
