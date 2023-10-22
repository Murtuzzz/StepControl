//
//  AppDelegate.swift
//  StepControl
//
//  Created by Мурат Кудухов on 30.08.2023.
//

import UIKit
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let center = UNUserNotificationCenter.current()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        center.requestAuthorization(options: [.alert, .sound]) { granted, error in
            if let error = error {
                print("Ошибка при запросе разрешения отправки уведомлений: \(error.localizedDescription)")
            } else {
                if granted {
                    print("Пользователь разрешил отправку уведомлений")
                } else {
                    print("Пользователь запретил отправку уведомлений")
                }
            }
        }
        
        UIWindow.appearance().overrideUserInterfaceStyle = .unspecified


        
        return true
    }
    
    func createNotification(title: String, body: String) {
        if UserSettings.notifications == true {
            print("Notifications active!")
            center.removeAllPendingNotificationRequests()
            let content = UNMutableNotificationContent()
            content.title = title
            content.body = body
            content.sound = UNNotificationSound.default
            
            let times = [[8, 0], [13, 0], [20, 0]] // Утро, полдень, вечер
            for time in times {
                var dateComponents = DateComponents()
                dateComponents.hour = time[0]
                dateComponents.minute = time[1]
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                
                center.add(request) { error in
                    if let error = error {
                        print("Не удалось добавить уведомление: \(error.localizedDescription)")
                    } else {
                        print("Уведомление добавлено успешно")
                    }
                }
            }
        } else {
            center.removeAllPendingNotificationRequests()
            print("Notifications disabled")
        }
    }



    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

