//
// Copyright 2016 - 2023 Anton Tananaev (anton@traccar.org)
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import UIKit
import UserNotifications
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        if UserDefaults.standard.object(forKey: "url") != nil {
            self.window = UIWindow(frame: UIScreen.main.bounds)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            self.window?.rootViewController = storyboard.instantiateViewController(withIdentifier: "MainViewController")
            self.window?.makeKeyAndVisible()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(onReceive(_:)), name: MainViewController.eventLogin, object: nil)

        #if FIREBASE

        FirebaseApp.configure()
            
        Messaging.messaging().delegate = self

        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }

        application.registerForRemoteNotifications()

        #endif

        return true
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
    }
    
    func application(
            _ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
            fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    @objc func onReceive(_ notification:Notification) {
        Messaging.messaging().token { (token, _) in
            if let token = token {
                NotificationCenter.default.post(
                    name: MainViewController.eventToken, object: nil, userInfo: [MainViewController.keyToken: token])
            }
        }
    }

}

@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(
            _ center: UNUserNotificationCenter, willPresent notification: UNNotification,
            withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {

        completionHandler([.alert, .sound])
    }
    
    func userNotificationCenter(
            _ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse,
            withCompletionHandler completionHandler: @escaping () -> Void) {

        if let eventId = response.notification.request.content.userInfo["eventId"] {
            NotificationCenter.default.post(
                name: MainViewController.eventEvent, object: nil, userInfo: [MainViewController.keyEventId: eventId])
        }
        completionHandler()
    }

}

extension AppDelegate : MessagingDelegate {

    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        if let fcmToken = fcmToken {
            NotificationCenter.default.post(
                name: MainViewController.eventToken, object: nil, userInfo: [MainViewController.keyToken: fcmToken])
        }
    }

}
