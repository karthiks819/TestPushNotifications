//
//  NotificationService.swift
//  ImageServiceExt
//
//  Created by KarthikSai on 14/05/20.
//  Copyright © 2020 Demo. All rights reserved.
//

import UserNotifications

//class NotificationService: UNNotificationServiceExtension {
//
//    var contentHandler: ((UNNotificationContent) -> Void)?
//    var bestAttemptContent: UNMutableNotificationContent?
//
//    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
//        self.contentHandler = contentHandler
//        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
//
//        if let bestAttemptContent = bestAttemptContent {
//            // Modify the notification content here...
//            bestAttemptContent.title = "\(bestAttemptContent.title) [modified]"
//
//            contentHandler(bestAttemptContent)
//        }
//
//
//
////        self.contentHandler = contentHandler
////               bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
////print("********************")
////               func failEarly() {
////                   contentHandler(request.content)
////               }
////
////               guard let content = (request.content.mutableCopy() as? UNMutableNotificationContent) else {
////                   return failEarly()
////               }
////
////               guard let apnsData = content.userInfo["data"] as? [String: Any] else {
////                   return failEarly()
////               }
////
////               guard let attachmentURL = apnsData["attachment-url"] as? String else {
////                   return failEarly()
////               }
////
////               guard let imageData = NSData(contentsOf:NSURL(string: attachmentURL)! as URL) else { return failEarly() }
////               guard let attachment = UNNotificationAttachment.create(imageFileIdentifier: "image.gif", data: imageData, options: nil) else { return failEarly() }
////
////        content.attachments = [attachment]
////                   contentHandler(content.copy() as! UNNotificationContent)
//
////        //Actions
////        let likeAction = UNNotificationAction(identifier: "meow", title: "Meow", options: [])
////
////        let addToCartAction = UNNotificationAction(identifier: "pizza", title: "Pizza?", options: [])
////
////        let category = UNNotificationCategory(identifier: "myCategory", actions: [likeAction, addToCartAction], intentIdentifiers: [], options: [])
////
////        UNUserNotificationCenter.current().setNotificationCategories([category])
//
//
//
//
//    }
//
//    override func serviceExtensionTimeWillExpire() {
//        // Called just before the extension will be terminated by the system.
//        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
//        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
//            contentHandler(bestAttemptContent)
//        }
//    }
//
//}

//extension UNNotificationAttachment {
//    /// Save the image to disk
//    static func create(imageFileIdentifier: String, data: NSData, options: [NSObject : AnyObject]?) -> UNNotificationAttachment? {
//
//            let fileManager = FileManager.default
//            let tmpSubFolderName = ProcessInfo.processInfo.globallyUniqueString
//            let fileURLPath      = NSURL(fileURLWithPath: NSTemporaryDirectory())
//            let tmpSubFolderURL  = fileURLPath.appendingPathComponent(tmpSubFolderName, isDirectory: true)
//
//            do {
//                try fileManager.createDirectory(at: tmpSubFolderURL!, withIntermediateDirectories: true, attributes: nil)
//                let fileURL = tmpSubFolderURL?.appendingPathComponent(imageFileIdentifier)
//                try data.write(to: fileURL!, options: [])
//                let imageAttachment = try UNNotificationAttachment.init(identifier: imageFileIdentifier, url: fileURL!, options: options)
//                return imageAttachment
//            } catch let error {
//                print("error \(error)")
//            }
//
//        return nil
//    }
//}


class NotificationService: UNNotificationServiceExtension {
 
    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?
 
     
         
    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
         
        if let bestAttemptContent = bestAttemptContent {
            print("****")
            let userInfo = bestAttemptContent.userInfo as! [String:Any]
            //change the subtitle
            if userInfo["subtitle"] != nil{
                bestAttemptContent.subtitle = userInfo["subtitle"] as! String
            }
            //change the content to the order
            if let orderEntry = userInfo["order"] {
                let orders = orderEntry as! [String]
                var body = ""
                for item in orders{
                    body += item + "\n "
                     
                }
                bestAttemptContent.body = body
            }
             
             
            contentHandler(bestAttemptContent)
        }
    }
     
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }
  
    func changePizzaNotification(content oldContent:UNNotificationContent) -> UNMutableNotificationContent{
        let content = oldContent.mutableCopy() as! UNMutableNotificationContent
        //get the dictionary
        let userInfo = content.userInfo as! [String:Any]
        //change the subtitle
        if let subtitle = userInfo["subtitle"]{
            content.subtitle = subtitle as! String
        }
         
        //change the body with the order
        if let orderEntry = userInfo["order"] {
            var body = ""
            let orders = orderEntry as! [String]
            for item in orders{
                body += item + ", "
            }
            content.body = body
        }
        return content
    }
}
