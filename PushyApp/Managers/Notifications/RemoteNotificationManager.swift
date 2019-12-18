import Foundation
import UserNotifications
import UIKit
import Combine

class RemoteNotificationManager: NSObject {
    private let notificationCenter = UNUserNotificationCenter.current()
    private let categories: [UNNotificationCategorizable] = [AcceptRejectCategory()]
    var methodPublisher = CurrentValueSubject<String, Never>("")
    
    
    override init() {
        super.init()
        notificationCenter.delegate = self
        registerCustomActions()
    }
    
    func registerCustomActions() {
        let categoriesSet = Set(categories.map({$0.notificationCategory}))
        notificationCenter.setNotificationCategories(categoriesSet)
    }
}

extension RemoteNotificationManager: RemoteNotificationManagerProtocol {
    func setupNotificationHandling() {
        notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if let error = error {
                //Handle this (Log it?)
                print(error.localizedDescription)
            } else if granted {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            } else {
                print("Ask user to enable in settings")
            }
        }
    }
    
    func handleNotificationRegistrationError(error: Error) {
        //Handle registration error
        print(error.localizedDescription)
    }
    
    func handleNotificationRegistrationSuccess(withDeviceToken token: Data) {
        let deviceToken = token.reduce("", {$0 + String(format: "%02X", $1)})
        //Send token to the push notifications provider
        print(deviceToken)
    }
    
    
    /// Handles silent notifications
    /// - Parameters:
    ///   - userInfo: Dictionary with notification payload
    ///   - completionHandler: completion handler to let the system know the status of the operation
    func handleSilentNotification(userInfo: [AnyHashable : Any],
                                  fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        methodPublisher.send("handle silent notification")
    }
}

extension RemoteNotificationManager: UNUserNotificationCenterDelegate {
    
    /// Handles foreground notifications
    /// - Parameters:
    ///   - center: Notification center
    ///   - notification: Received notification
    ///   - completionHandler: completion handler that handles what of the notification is shown to the user if any (ex: alert, sound, badge)
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void){
        methodPublisher.send("handle foreground notification")
        completionHandler([])
    }
    
    /// Handles notifications when the app is in the background or inactive
    /// - Parameters:
    ///   - center: Notification center
    ///   - response: Notification response
    ///   - completionHandler: completion once the notification has been acted upon
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        defer { completionHandler() }
        methodPublisher.send("handle background notification")
        
        let identity = response.notification.request.content.categoryIdentifier
        print(identity)
        print("You pressed \(response.actionIdentifier)")
    }
}

protocol RemoteNotificationManagerProtocol {
    //this porperty is just for demo purposes to showcase the method names called. Remove in actual project.
    var methodPublisher: CurrentValueSubject<String, Never> { get }
    
    
    /// Setups the notification handling by requesting authorization and calling appropriate methods
    func setupNotificationHandling()
    func handleNotificationRegistrationError(error: Error)
    func handleNotificationRegistrationSuccess(withDeviceToken token: Data)
    func handleSilentNotification(userInfo: [AnyHashable : Any],
                                  fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void)
}

