//
//  popUpReminderView.swift
//  Noteapp
//
//  Created by Apple on 24/04/19.
//  Copyright © 2019 JP.LLC. All rights reserved.
//

import UIKit

class popUpReminderView: UIViewController,UINavigationControllerDelegate,UINavigationBarDelegate {

    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var dateTimePicker: UIDatePicker!
    @IBOutlet weak var setButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.dateTimePicker.minimumDate = Date()
        self.dateTimePicker.date = Date().addingTimeInterval(60)
    }

    
    @IBAction func saveButton(_ sender: Any) {
    
        let nextData = NotificationManager.shared.setReminter(date: self.dateTimePicker.date)
      
        dismiss(animated: true)
    }
    
    
    @IBAction func cancelButton(_ sender: Any) {
   
     NotificationManager.shared.cancelAllNotifcation()
         self.navigationController?.popToRootViewController(animated: true)
    
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {return .lightContent}
}


extension TimeInterval{
    
    
    var formattedTime:String{
        
        
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .brief
        formatter.includesApproximationPhrase = false
        formatter.includesTimeRemainingPhrase = false
        formatter.allowedUnits = [.hour,.minute,.second]
        formatter.calendar = Calendar.current
        
        
        return formatter.string(from: self) ?? ""
        
    }
    

}
