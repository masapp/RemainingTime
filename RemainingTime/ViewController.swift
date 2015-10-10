//
//  ViewController.swift
//  RemainingTime
//
//  Created by masapp on 2015/06/21.
//  Copyright (c) 2015年 masapp. All rights reserved.
//

import UIKit

@available(iOS 8.0, *)
class ViewController: UIViewController {
    
    var appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    let defaults = NSUserDefaults.standardUserDefaults()
    let yearTime: Double = 31536000
    let dateFormatter = NSDateFormatter()
    
    // Screen size
    let screenWidth = UIScreen.mainScreen().bounds.width
    let screenHeight = UIScreen.mainScreen().bounds.height
    
    // Size change magnification by the device
    let wscale = UIScreen.mainScreen().bounds.width / 320
    let hscale = UIScreen.mainScreen().bounds.height / 568
    
    var calendar: NSCalendar!
    
    var days: UILabel!
    var times: UILabel!
    
    var now: NSDate!
    var nowYear: Int!
    var month: Int!
    var day: Int!
    var birthDateUnix: Double!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        now = NSDate()
        dateFormatter.dateFormat = "yyyy M d"
        
        initializeView()
        
        if ((UIDevice.currentDevice().systemVersion as NSString).floatValue >= 8.0) {
            calendar = NSCalendar(identifier: NSGregorianCalendar)
        } else {
            calendar = NSCalendar(calendarIdentifier: NSGregorianCalendar)
        }
        nowYear = calendar!.components(NSCalendarUnit.NSYearCalendarUnit, fromDate: now).year
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(false)
        
        if (defaults.stringForKey("Month") == nil) {
            month = 1
        } else {
            month = Int(defaults.stringForKey("Month")!)
        }
        
        if (defaults.stringForKey("Day") == nil) {
            day = 1
        } else {
            day = Int(defaults.stringForKey("Day")!)
        }
        
        updateLabel()

        if (appDelegate.isAlert == true && defaults.boolForKey("Noti") == true) {
            UIApplication.sharedApplication().cancelAllLocalNotifications()
            setNotification()
        }
        
        NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "updateRemaining:", userInfo: nil, repeats: true)
    }
    
    func initializeView() {
        let back: UIImageView = UIImageView(image: UIImage(named: "wall.png"))
        back.frame = UIScreen.mainScreen().bounds
        self.view.addSubview(back)
        
        let titleLabel: UILabel = UILabel(frame: CGRectMake(0 * wscale, 30 * hscale, screenWidth, 50 * hscale))
        titleLabel.text = "To go until birthday"
        titleLabel.font = UIFont(name: "Chalkduster", size: 27 * wscale)
        titleLabel.textAlignment = NSTextAlignment.Center
        self.view.addSubview(titleLabel)
        
        let dayLabel: UILabel = UILabel(frame: CGRectMake(50 * wscale, 100 * hscale, 100 * wscale, 50 * hscale))
        dayLabel.text = "Days"
        dayLabel.font = UIFont(name: "Chalkduster", size: 30 * wscale)
        self.view.addSubview(dayLabel)
        
        let timeLabel: UILabel = UILabel(frame: CGRectMake(50 * wscale, 250 * hscale, 100 * wscale, 50 * hscale))
        timeLabel.text = "Times"
        timeLabel.font = UIFont(name: "Chalkduster", size: 30 * wscale)
        self.view.addSubview(timeLabel)
        
        let setting: UIButton = UIButton(frame: CGRectMake(65 * wscale, 450 * hscale, 200 * wscale, 50 * hscale))
        setting.setTitle("setting", forState: .Normal)
        setting.setTitleColor(UIColor.blackColor(), forState: .Normal)
        setting.titleLabel?.font = UIFont(name: "Chalkduster", size: 25 * wscale)
        setting.titleLabel?.textAlignment = NSTextAlignment.Center
        setting.addTarget(self, action: "moveSetting:", forControlEvents: .TouchUpInside)
        self.view.addSubview(setting)
        
        days = UILabel(frame: CGRectMake(0 * wscale, 180 * hscale, screenWidth, 50 * hscale))
        days.font = UIFont(name: "Chalkduster", size: 40 * wscale)
        days.textAlignment = NSTextAlignment.Center
        self.view.addSubview(days)
        
        times = UILabel(frame: CGRectMake(0 * wscale, 330 * hscale, screenWidth, 50 * hscale))
        times.font = UIFont(name: "Chalkduster", size: 40 * wscale)
        times.textAlignment = NSTextAlignment.Center
        self.view.addSubview(times)

    }
    
    func moveSetting(sender: UIButton) {
        let settingViewController: UIViewController = SettingViewController()
        settingViewController.modalTransitionStyle = UIModalTransitionStyle.PartialCurl
        self.presentViewController(settingViewController, animated: true, completion: nil)
    }
    
    func calcRemainingTime(_year: Int) -> Double {
        let birthDate: String = NSString(format: "%d %d %d", _year, month!, day!) as String
        birthDateUnix = dateFormatter.dateFromString(birthDate)?.timeIntervalSince1970
        let nowUnix = now.timeIntervalSince1970
        
        return birthDateUnix! - nowUnix
    }
    
    func updateRemaining(timer: NSTimer) {
        now = NSDate()
        updateLabel()
    }
    
    func updateLabel() {
        var remainingTime = calcRemainingTime(nowYear!)
        if (remainingTime < 0) {
            remainingTime = calcRemainingTime(nowYear! + 1)
        }
        
        days?.text = NSString(format: "%.0f", remainingTime / (24 * 60 * 60)) as String
        times?.text = NSString(format: "%.0f", remainingTime) as String

    }
    
    func setNotification() {
        let notification: UILocalNotification = UILocalNotification()
        notification.fireDate = NSDate(timeIntervalSince1970: birthDateUnix)
        notification.timeZone = NSTimeZone.defaultTimeZone()
        notification.alertBody = "Happy Birth Day!"
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
}

