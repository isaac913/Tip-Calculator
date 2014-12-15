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
        tipLabel.text = "$0.00";
        totalLabel.text = "$0.00";
        tooMuchWarningLabel.hidden = true;
        billAmountTextField.delegate = self;
        dogPic.hidden = true;

        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        billAmountTextField.becomeFirstResponder();
        
        var tap = UITapGestureRecognizer(target: self, action: Selector("onTap"));

        view.addGestureRecognizer(tap);
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated);
        dogPic.hidden = false;
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
        let newString = (textField.text as NSString).stringByReplacingCharactersInRange(range, withString: string);
        var ret : Bool = countElements(newString.stringByTrimmingCharactersInSet(NSCharacterSet.decimalDigitCharacterSet())) < 2;
        
        if ret{
            let amount =  (newString as NSString).doubleValue;
            
            let notOverLimit : Bool = amount < maxAmount;
            
            if notOverLimit
            {
                updateTipInfo(amount);
            }
            
            tooMuchWarningLabel.hidden = notOverLimit;
            ret = notOverLimit;
        }
        
        return ret;
    }
    
//    @IBAction func OnEditingChange(sender: UITextField)
//    {
//        let amount = (billAmountTextField.text as NSString).doubleValue;
//        let notOverLimit : Bool = amount < maxAmount;
//        
//        if(notOverLimit)
//        {
//            var currentPercentage = (percentSegmentController.titleForSegmentAtIndex(percentSegmentController.selectedSegmentIndex) as NSString).doubleValue * 0.01;
//            
//            var tip = amount * currentPercentage;
//            var total = amount + tip;
//            
//            tipLabel.text = String(format: "$%0.2f", tip);
//            totalLabel.text = String(format:"$%0.2f", total);
//            currentValue = amount;
//        }
//        
//        billAmountTextField.text = "$\(currentValue)";
//        tooMuchWarningLabel.hidden = notOverLimit;
//    }

    func updateTipInfo(amount:Double)
    {
        var currentPercentage = (percentSegmentController.titleForSegmentAtIndex(percentSegmentController.selectedSegmentIndex) as NSString).doubleValue * 0.01;
        
        var tip = amount * currentPercentage;
        var total = amount + tip;
        
        tipLabel.text = String(format: "$%0.2f", tip);
        totalLabel.text = String(format:"$%0.2f", total);
        currentValue = amount;
    }
    
    
    
    @IBAction func OnPercentValueChanged(sender: UISegmentedControl) {
        updateTipInfo(currentValue);
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
