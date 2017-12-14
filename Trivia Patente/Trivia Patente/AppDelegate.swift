//
//  AppDelegate.swift
//  Trivia Patente
//
//  Created by Antonio Terpin on 02/10/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit
import Alamofire
import UserNotifications
import Firebase
import GoogleMobileAds

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate, UNUserNotificationCenterDelegate {
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        FirebaseManager.obtainToken(token: fcmToken)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        if FirebaseManager.canDisplayNotification(notification: notification) && SessionManager.currentUser != nil {
            completionHandler([.sound, .alert, .badge])
        }
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        MainViewController.pushGame = FirebaseManager.getGameFrom(notification: response.notification)
        MainViewController.pushGame?.opponent = FirebaseManager.getOpponentFrom(notification: response.notification)
        let application = UIApplication.shared
        if application.applicationState == .active || application.applicationState == .background {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let main = storyboard.instantiateInitialViewController()
            self.changeRootViewController(with: main)
        }
        completionHandler()
    }

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //SessionManager.drop()
        UIApplication.shared.statusBarStyle = .lightContent
        self.window?.rootViewController = UIViewController.root()
//        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        FirebaseManager.initialize(delegate: self)
        // Initialize the Google Mobile Ads SDK.
        GADMobileAds.configure(withApplicationID: "ca-app-pub-6517751265585915~9911714540")
        return true
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().setAPNSToken(deviceToken, type: .unknown)
        if let token = Messaging.messaging().fcmToken {
            FirebaseManager.obtainToken(token: token)
        }
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
//        return FBSDKApplicationDelegate.sharedInstance().application(app, open: url, options: options)
        return false
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        SocketManager.disconnect {}
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//        FBSDKAppEvents.activateApp()
        if SessionManager.isLogged() {
            SocketManager.connect(handler: {}) {
                MainViewController.handleSocketDisconnection()
            }
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        SocketManager.disconnect { }
    }
    
    func changeRootViewController(with controller:UIViewController!) {
        let snapshot:UIView = (self.window?.snapshotView(afterScreenUpdates: true))!
        controller?.view.addSubview(snapshot);
        
        self.window?.rootViewController = controller;
        
        UIView.animate(withDuration: 0.3, animations: {() in
            snapshot.layer.opacity = 0;
            snapshot.layer.transform = CATransform3DMakeScale(1.5, 1.5, 1.5);
        }, completion: {
            (value: Bool) in
            snapshot.removeFromSuperview();
        });
    }
    
    func shareAppLink(controller: UIViewController)
    {
        let textToShare = "Scarica anche tu TriviaPatente e prova a battermi https://shesh.com"
        
        if let myWebsite = NSURL(string: "http://www.apple.com/") {
            let objectsToShare = [textToShare, myWebsite] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            activityVC.popoverPresentationController?.sourceView = controller.view
            controller.present(activityVC, animated: true, completion: nil)
        }
    }
    
    override init() {
        super.init()
        UIFont.overrideInitialize()
    }


}

