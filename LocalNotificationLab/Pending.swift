//
//  Pending.swift
//  LocalNotificationLab
//
//  Created by Ian Bailey on 2/25/20.
//  Copyright © 2020 Ian Bailey. All rights reserved.
//

import Foundation
import UserNotifications

class PendingNotification {
    public func getPendingNotifications(completion: @escaping ([UNNotificationRequest])->())  {
        UNUserNotificationCenter.current().getPendingNotificationRequests { (requests) in
            print("there are \(requests.count) pending requests.")
            completion(requests)
        }
    }
}
