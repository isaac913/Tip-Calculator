//
//  TipCalculatorViewController.swift
//  TipCalculator
//
//  Created by isaac on 12/14/14.
//  Copyright (c) 2014 Isaac Zhang. All rights reserved.
//

import UIKit
class TipCalculatorViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var billAmountTextField: UITextField!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var percentSegmentController: UISegmentedControl!
    @IBOutlet weak var tooMuchWarningLabel: UILabel!
    
    @IBOutlet weak var dogPic: UIImageView!
    var currentValue : Double = 0.0;
    
    let maxAmount:Double = 50000000;

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "settings", style: UIBarButtonItemStyle.Bordered, target: self, action: "goToSetting");
        tipLabel.text = "$0.00";
        totalLabel.text = "$0.00";
        tooMuchWarningLabel.hidden = true;
        billAmountTextField.delegate = self;
        dogPic.hidden = true;
        
        percentSegmentController.selectedSegmentIndex = NSUserDefaults.standardUserDefaults().integerForKey("initPercentage");

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        let defaults = NSUserDefaults.standardUserDefaults();
        
        billAmountTextField.becomeFirstResponder();
        let savedDate: NSDate = NSDate(timeIntervalSince1970: defaults.doubleForKey("savedDate"));
        let diff : NSTimeInterval = NSDate().timeIntervalSinceDate(savedDate);
        
        if  diff < 5 * 60 // saved less than 5 mins ago
        {
            let oldAmount : Double = defaults.doubleForKey("billAmount");
            billAmountTextField.text = String(format: "%0.2f", oldAmount);
            updateTipInfo(oldAmount);
        }
        
        var tap = UITapGestureRecognizer(target: self, action: Selector("onTap"));
        view.addGestureRecognizer(tap);
        
        self.navigationController?.navigationBar.barTintColor = UIColor.whiteColor();
        self.navigationController?.navigationBar.tintColor = UIColor.blueColor();
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated);
        dogPic.hidden = false;
    }

    
    func goToSetting()
    {
        self.performSegueWithIdentifier("goSetting", sender: self);
    }
    
    
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func onTap()
    {
        view.endEditing(true);

    }
    
    func textField(textField: UITextField!, shouldChangeCharactersInRange range: NSRange, replacementString string: String!) -> Bool
    {
        var newString = (textField.text as NSString).stringByReplacingCharactersInRange(range, withString: string);
        
        newString = getTrimmedString(newString);
        
        var ret : Bool = countElements(newString.stringByTrimmingCharactersInSet(NSCharacterSet.decimalDigitCharacterSet())) < 2;
        
        if ret{
            let amount =  (newString as NSString).doubleValue;
            
            let notOverLimit : Bool = amount < maxAmount;
            
            if notOverLimit
            {
                updateTipInfo(amount);
                
                saveBillAmount(amount);
            }
            
            tooMuchWarningLabel.hidden = notOverLimit;
            ret = notOverLimit;
        }
        
        
        
        return ret;
    }
    
    
    func saveBillAmount(amount:Double)
    {
        let defaults = NSUserDefaults.standardUserDefaults();
        
        defaults.setDouble(amount, forKey: "billAmount");
        defaults.setObject(NSDate().timeIntervalSince1970, forKey: "savedDate");
    }
    
    func updateTipInfo(amount:Double)
    {
        var currentPercentage : Double =  getCurrentPerCentage();
        
        var tip = amount * currentPercentage;
        var total = amount + tip;
        
        tipLabel.text = getMoneyFormatString(tip);
        totalLabel.text = getMoneyFormatString(total);
        currentValue = amount;
    }
    
    func getCurrentPerCentage() -> Double
    {
        return (percentSegmentController.titleForSegmentAtIndex(percentSegmentController.selectedSegmentIndex)! as NSString).doubleValue * 0.01
    }
    
    @IBAction func OnPercentValueChanged(sender: UISegmentedControl) {
        updateTipInfo(currentValue);
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
    }
    
    
    func getTrimmedString(input : String) -> String
    {
//        "^?[0-9]*\\.?[0-9]+$"
        let match = input.rangeOfString("^?[0-9]*\\.*", options: .RegularExpressionSearch);
        
        if (match != nil){
            return input.substringWithRange(match!);
        }
        else{
            return "";
        }
    }
    
    
    func getMoneyFormatString(amount: Double) -> String
    {
        return String(format:"$%0.2f", amount);
    }
    
}
