import UserNotifications

struct AcceptRejectCategory: UNNotificationCategorizable {
    private let identifier = "AcceptOrRejectCategory"
    
    var notificationCategory: UNNotificationCategory {
        var actions = [UNNotificationAction]()
        for action in ActionIdentifier.allCases {
            let notificationAction = UNNotificationAction(identifier: action.rawValue, title: action.rawValue)
            actions.append(notificationAction)
        }
        return UNNotificationCategory(identifier: identifier, actions: actions, intentIdentifiers: [])
    }
    
    private enum ActionIdentifier: String, CaseIterable {
        case accept = "Accept"
        case reject = "Reject"
    }
}


protocol UNNotificationCategorizable {
    var notificationCategory: UNNotificationCategory {get}
}
