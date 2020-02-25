//
//  NotificationViewController.swift
//  LocalNotificationLab
//
//  Created by Ian Bailey on 2/20/20.
//  Copyright © 2020 Ian Bailey. All rights reserved.
//

import UIKit

class NotificationViewController: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    
    
    private let center = UNUserNotificationCenter.current()
    
    private let pendingNotification = PendingNotification()
    
    private var notifications = [UNNotificationRequest]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    private var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        configureRefreshControll()
        checkForNotificationAuthorization()
        loadNotifications()
        center.delegate = self
    }

    private func checkForNotificationAuthorization() {
        center.getNotificationSettings { (settings) in
            if settings.authorizationStatus == .authorized {
                print("authorized")
            } else {
                self.requestNotificationPermissions()
            }
        }
    }
    private func requestNotificationPermissions() {
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            if let error = error {
                print("error requesting authorization: \(error)")
                return
            }
            if granted {
                print("Granted")
            } else {
                print("Denied")
            }
        }
    }


private func configureRefreshControll() {
    refreshControl = UIRefreshControl()
    tableView.refreshControl = refreshControl
    refreshControl.addTarget(self, action: #selector(loadNotifications), for: .valueChanged)
}

@objc private func loadNotifications() {
       pendingNotification.getPendingNotifications{ (requests) in
           self.notifications = requests
           DispatchQueue.main.async {
               self.refreshControl.endRefreshing()
           }
       }
   }
}
extension NotificationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "notificationCell", for: indexPath)
        let notification = notifications[indexPath.row]
        cell.textLabel?.text = notification.content.title
        cell.detailTextLabel?.text = notification.content.body
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //we will delete the pending notification
            removeNotification(atIndexPath: indexPath)
        }
    }
    private func removeNotification(atIndexPath indexPath: IndexPath) {
           let notification = notifications[indexPath.row]
           let identifier = notification.identifier
           center.removePendingNotificationRequests(withIdentifiers: [identifier])
           notifications.remove(at: indexPath.row)
           tableView.deleteRows(at: [indexPath], with: .automatic)
           
       }
}

extension NotificationViewController: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(.alert)
    }
}

extension NotificationViewController: CreateNotificationDelegate {
    func didCreateNotification(_ createNotificationController: TimerViewController) {
        loadNotifications()
    }
}
