//
//  AmazonTool.swift
//  Streamini
//
//  Created by Vasily Evreinov on 01/07/15.
//  Copyright (c) 2015 UniProgy s.r.o. All rights reserved.
//

import UIKit

protocol AmazonToolDelegate: class {
    func imageDidUpload()
    func imageUploadFailed(error: NSError)
}

class AmazonTool: NSObject {
    weak var delegate: AmazonToolDelegate?
    
    class var shared : AmazonTool {
        struct Static {
            static let instance : AmazonTool = AmazonTool()
        }
        return Static.instance
    }
    
    class func isAmazonSupported() -> Bool {
        let (accessKeyId, _, _, _) = Config.shared.amazon()
        return !accessKeyId.isEmpty
    }
    
    override init () {
        super.init()
        
        // Setup Amazon S3
        AWSLogger.defaultLogger().logLevel = .Error
        
        let (accessKeyId, secretAccessKey, _, _) = Config.shared.amazon()
        let credentialsProvider = AWSStaticCredentialsProvider(accessKey: accessKeyId, secretKey: secretAccessKey)
        let configuration = AWSServiceConfiguration(region: AWSRegionType.USEast1, credentialsProvider: credentialsProvider)
        AWSServiceManager.defaultServiceManager().defaultServiceConfiguration = configuration
    }
    
    func uploadImage(image: UIImage, name: String) {
        uploadImage(image, name: name, uploadProgress: nil)
    }
    
    func uploadImage(image: UIImage, name: String, uploadProgress: AWSNetworkingUploadProgressBlock?) {
        let (_, _, _, imagesBucket) = Config.shared.amazon()
        let uploadRequest = AWSS3TransferManagerUploadRequest()
        uploadRequest.key = name
        uploadRequest.bucket = imagesBucket
        
        if let progress = uploadProgress {
            uploadRequest.uploadProgress = progress
        }
        
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let basePath = paths[0] 
        let filePath = (basePath as NSString).stringByAppendingPathComponent(name)
        let binaryImageData = UIImageJPEGRepresentation(image, 1.0)
        binaryImageData!.writeToFile(filePath, atomically: true)
        
        let fileURL = NSURL(fileURLWithPath: filePath)
        
        uploadRequest.body = fileURL
        
        let transferManager = AWSS3TransferManager.defaultS3TransferManager()
        transferManager.upload(uploadRequest).continueWithExecutor(AWSExecutor.mainThreadExecutor(), withBlock: { (task) -> AnyObject! in
            do {
                try NSFileManager.defaultManager().removeItemAtURL(fileURL)
            } catch _ {
            }
            if let del = self.delegate {
                if let error = task.error {
                    del.imageUploadFailed(error)
                } else {
                    del.imageDidUpload()
                }
            }
            
            return nil
        })
    }
}
