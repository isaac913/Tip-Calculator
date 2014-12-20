//
//  SettingsViewController.swift
//  TipCalculator
//
//  Created by isaac on 12/18/14.
//  Copyright (c) 2014 Isaac Zhang. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var defaultTipPercentageControl: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        defaultTipPercentageControl.selectedSegmentIndex = NSUserDefaults.standardUserDefaults().integerForKey("initPercentage");
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        self.navigationController?.navigationBar.barTintColor = UIColor.blackColor();
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onValueChanged(sender: UISegmentedControl) {
        NSUserDefaults.standardUserDefaults().setInteger(sender.selectedSegmentIndex, forKey: "initPercentage");
        
        NSUserDefaults.standardUserDefaults().synchronize();
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
