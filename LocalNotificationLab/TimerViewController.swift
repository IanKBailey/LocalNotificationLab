//
//  TimerViewController.swift
//  LocalNotificationLab
//
//  Created by Ian Bailey on 2/20/20.
//  Copyright © 2020 Ian Bailey. All rights reserved.
//

import UIKit


protocol CreateNotificationDelegate: AnyObject {
    func didCreateNotification(_ createNotificationController:TimerViewController)
}
class TimerViewController: UIViewController {

    
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    weak var delegate: CreateNotificationDelegate?
    
    private var timeInt: TimeInterval = Date().timeIntervalSinceNow + 5 //testing
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    
    private func createLocalNotification() {
    let content = UNMutableNotificationContent()
    content.title = textField.text ?? "No title"
    
    let identifier = UUID().uuidString
    if let imageURL = Bundle.main.url(forResource: "duck", withExtension: "jpg") {
        do {
            let attachment = try UNNotificationAttachment(identifier: identifier, url: imageURL, options: nil)
            content.attachments = [attachment]
        } catch {
            print("error with attachment")
        }
    } else {
        print("image resource could not be found")
    }
    
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInt, repeats: false)
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
    
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("error adding request: \(error)")
            } else {
                print("request was successfully found")
            }
        }
    
    }
    
    
    
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        createLocalNotification()
        delegate?.didCreateNotification(self)
        dismiss(animated: true)
    }

    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        timeInt = sender.countDownDuration
    }
    
}
