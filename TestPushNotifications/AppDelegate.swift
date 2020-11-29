//
//  AppDelegate.swift
//  TestPushNotifications
//
//  Created by KarthikSai on 11/05/20.
//  Copyright © 2020 Demo. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

   var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.registerForPushNotifications()
        UNUserNotificationCenter.current().delegate = self
        
        setCategories()
        return true
    }

    // MARK: UISceneSession Lifecycle

//    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
//        // Called when a new scene session is being created.
//        // Use this method to select a configuration to create the new scene with.
//        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
//    }
//
//    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
//        // Called when the user discards a scene session.
//        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
//        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
//    }


    func registerForPushNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge]) { (granted, err) in
            if granted {
                print("registered successfully")
            }else {
                print("error")
            }
        }
    }
    
    
     //MARK: - Delegates for Notifications
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let action = response.actionIdentifier
        let request = response.notification.request
        let content = request.content
        
        
        switch action {
        case "ACCEPT_ACTION":
            print("accepted")
        case "DECLINE_ACTION":
            print("declined")
            
        case "meow":
            print("Meoew")
        case "pizza":
            print("pizza")
        case "snooze.action":
            let snoozeTrigger = UNTimeIntervalNotificationTrigger(
                timeInterval: 5.0,
                repeats: false)
            let snoozeRequest = UNNotificationRequest(
                identifier: "pizza.snooze",
                content: content,
                trigger: snoozeTrigger)
            center.add(snoozeRequest){
                (error) in
                if error != nil {
                    print("Snooze Request Error: \(String(describing: error?.localizedDescription))")
                }
            }
        default:
            print("invalid selection of identifier")
        }
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("Push notification received in foreground.")
        completionHandler([.alert, .sound, .badge])
    }
    
    func setCategories(){
       let snoozeAction = UNNotificationAction(identifier: "snooze.action", title: "Snooze", options: [])
        let pizzaCategory = UNNotificationCategory(
        identifier: "pizza.category",
        actions: [snoozeAction],
        intentIdentifiers: [],
        options: [])
//        UNUserNotificationCenter.current().setNotificationCategories(
//                [pizzaCategory])
        
        
        
        //Meeting Category
        //Btn-1
        let acceptAction = UNNotificationAction(identifier: "ACCEPT_ACTION", title: "Accept", options: UNNotificationActionOptions(rawValue: 0))
        
        //Btn-2
        let declineAction = UNNotificationAction(identifier: "DECLINE_ACTION", title: "Decline", options: UNNotificationActionOptions(rawValue: 0))
        
        
        // Define the notification type
        
        let meetingTypeNotificationCat = UNNotificationCategory(identifier: "MEETING_INVITATION", actions: [acceptAction, declineAction], intentIdentifiers: [], hiddenPreviewsBodyPlaceholder: "", options: [.customDismissAction])
         
        
        
        
        //New image buttons and category
        //Actions
        let likeAction = UNNotificationAction(identifier: "meow", title: "Meow", options: [])
        
        let addToCartAction = UNNotificationAction(identifier: "pizza", title: "Pizza?", options: [])
        
        let category = UNNotificationCategory(identifier: "myCategory", actions: [likeAction, addToCartAction], intentIdentifiers: [], options: [])
        
//        UNUserNotificationCenter.current().setNotificationCategories([category])
        //debitOverdraftNotification Category
        let debitOverdraftNotifCategory = UNNotificationCategory(identifier: "debitOverdraftNotification", actions: [], intentIdentifiers: [], options: [])
               UNUserNotificationCenter.current().setNotificationCategories([debitOverdraftNotifCategory, pizzaCategory, meetingTypeNotificationCat, category])
                  }
           
        
   
    
}

