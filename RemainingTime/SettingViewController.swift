//
//  SettingViewController.swift
//  RemainingTime
//
//  Created by masapp on 2015/06/21.
//  Copyright (c) 2015年 masapp. All rights reserved.
//

import UIKit

@available(iOS 8.0, *)
class SettingViewController: UIViewController, UIAlertViewDelegate {
    
    var appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    // Screen size
    let screenWidth = UIScreen.mainScreen().bounds.width
    let screenHeight = UIScreen.mainScreen().bounds.height
    
    // Size change magnification by the device
    let wscale = UIScreen.mainScreen().bounds.width / 320
    let hscale = UIScreen.mainScreen().bounds.height / 568
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    var selectMonth: UILabel!
    var selectDay: UILabel!
    
    var month: Double!
    var day: Double!
    
    var noti: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        initializeView()
        
        if (defaults.stringForKey("Month") == nil) {
            selectMonth.text = "1"
            month = 1
        } else {
            selectMonth.text = defaults.stringForKey("Month")
            month = atof(defaults.stringForKey("Month")!)
        }
        
        if (defaults.stringForKey("Day") == nil) {
            selectDay.text = "1"
            day = 1
        } else {
            selectDay.text = defaults.stringForKey("Day")
            day = atof(defaults.stringForKey("Day")!)
        }
        
        if (appDelegate.isAlert == true) {
            noti = defaults.boolForKey("Noti")
        } else {
            noti = false
        }
        
        let monthStepper: UIStepper = UIStepper()
        monthStepper.center = CGPointMake(250 * wscale, 235 * hscale)
        monthStepper.backgroundColor = UIColor(red:1.0, green:1.0, blue:1.0, alpha:0.6)
        monthStepper.tintColor = UIColor.blackColor()
        monthStepper.minimumValue = 1
        monthStepper.maximumValue = 12
        monthStepper.stepValue = 1
        monthStepper.value = month!
        monthStepper.addTarget(self, action: "addMonthCount:", forControlEvents: UIControlEvents.ValueChanged)
        self.view.addSubview(monthStepper)
        
        let dayStepper: UIStepper = UIStepper()
        dayStepper.center = CGPointMake(250 * wscale, 285 * hscale)
        dayStepper.backgroundColor = UIColor(red:1.0, green:1.0, blue:1.0, alpha:0.6)
        dayStepper.tintColor = UIColor.blackColor()
        dayStepper.minimumValue = 1
        dayStepper.maximumValue = 31
        dayStepper.stepValue = 1
        dayStepper.value = day!
        dayStepper.addTarget(self, action: "addDayCount:", forControlEvents: UIControlEvents.ValueChanged)
        self.view.addSubview(dayStepper)
        
        let notificationSwitch: UISwitch = UISwitch()
        notificationSwitch.center = CGPointMake(250 * wscale, 335 * hscale)
        notificationSwitch.tintColor = UIColor.blackColor()
        notificationSwitch.on = noti
        notificationSwitch.addTarget(self, action: "switchChanged:", forControlEvents: .ValueChanged)
        self.view.addSubview(notificationSwitch)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initializeView() {
        let back: UIImageView = UIImageView(image: UIImage(named: "wall.png"))
        back.frame = UIScreen.mainScreen().bounds
        self.view.addSubview(back)
        
        let titleLabel: UILabel = UILabel(frame: CGRectMake(0 * wscale, 30 * hscale, screenWidth, 50 * hscale))
        titleLabel.text = "Select the date of birth"
        titleLabel.font = UIFont(name: "Chalkduster", size: 23 * wscale)
        titleLabel.textAlignment = NSTextAlignment.Center
        self.view.addSubview(titleLabel)
        
        let monthLabel: UILabel = UILabel(frame: CGRectMake(20 * wscale, 210 * hscale, 100 * wscale, 50 * hscale))
        monthLabel.text = "Month"
        monthLabel.font = UIFont(name: "Chalkduster", size: 27 * wscale)
        self.view.addSubview(monthLabel)
        
        let dayLabel: UILabel = UILabel(frame: CGRectMake(20 * wscale, 260 * hscale, 100 * wscale, 50 * hscale))
        dayLabel.text = "Day"
        dayLabel.font = UIFont(name: "Chalkduster", size: 27 * wscale)
        self.view.addSubview(dayLabel)
        
        let notificationLabel: UILabel = UILabel(frame: CGRectMake(20 * wscale, 310 * hscale, 200 * wscale, 50 * hscale))
        notificationLabel.text = "Notification"
        notificationLabel.font = UIFont(name: "Chalkduster", size: 25 * wscale)
        self.view.addSubview(notificationLabel)
        
        let save: UIButton = UIButton(frame: CGRectMake(65 * wscale, 450 * hscale, 200 * wscale, 50 * hscale))
        save.setTitle("save", forState: .Normal)
        save.setTitleColor(UIColor.blackColor(), forState: .Normal)
        save.titleLabel?.font = UIFont(name: "Chalkduster", size: 25 * wscale)
        save.titleLabel?.textAlignment = NSTextAlignment.Center
        save.addTarget(self, action: "saveBirthday:", forControlEvents: .TouchUpInside)
        self.view.addSubview(save)
        
        selectMonth = UILabel(frame: CGRectMake(130 * wscale, 210 * hscale, 100 * wscale, 50 * hscale))
        selectMonth.font = UIFont(name: "Chalkduster", size: 40 * wscale)
        self.view.addSubview(selectMonth)
        
        selectDay = UILabel(frame: CGRectMake(130 * wscale, 260 * hscale, 100 * wscale, 50 * hscale))
        selectDay.font = UIFont(name: "Chalkduster", size: 40 * wscale)
        self.view.addSubview(selectDay)
    }
    
    func saveBirthday(sender: UIButton) {
        defaults.setObject(NSString(format: "%.0f", month!), forKey: "Month")
        defaults.setObject(NSString(format: "%.0f", day!), forKey: "Day")
        defaults.setBool(noti, forKey: "Noti")
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func addMonthCount(stepper: UIStepper) {
        month = stepper.value
        selectMonth.text = NSString(format: "%.0f", month!) as String
    }
    
    func addDayCount(stepper: UIStepper) {
        day = stepper.value
        selectDay.text = NSString(format: "%.0f", day!) as String
    }
    
    func switchChanged(sender: UISwitch) {
        if (appDelegate.isAlert == true) {
            noti = sender.on
        } else {
            if objc_getClass("UIAlertController") != nil {
                let alertController = UIAlertController(title: "Notification is not allowed", message: "Please restart after allowing a notification", preferredStyle: .Alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                
                presentViewController(alertController, animated: true, completion: nil)
                
            } else {
                let alertView = UIAlertView(title: "Notification is not allowed", message: "Please restart after allowing a notification", delegate: self, cancelButtonTitle: nil, otherButtonTitles: "OK")
                alertView.show()
            }
            
            sender.on = false
        }
    }
}