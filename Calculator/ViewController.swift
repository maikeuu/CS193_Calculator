//
//  ViewController.swift
//  Calculator
//
//  Created by Mike Lin on 12/8/17.
//  Copyright © 2017 Mike Lin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var userIsTyping = false
    var haveDecimal = false
    
    //Property of the class
    //Refers to the "label", the display of the calculator
    @IBOutlet weak var display: UILabel! //Implicitly unwrapped
    
    
    
    /**
     * This function updates the calculator's display based off of
     * the button the user typed. The label is updated by replacing
     * the label's text with the title of the button
     */
    @IBAction func TouchDigit(_ sender: UIButton) {
        //digit received from button's title
        let digit = sender.currentTitle!
        
        if userIsTyping {
            let textInDisplay = display.text!//Unravel display already in text
            haveDecimal = textInDisplay.contains(".") ? true : false
            if digit == "." {
                if !haveDecimal { //If you don't have decimal, add it
                display.text = textInDisplay + digit
                } else {} //Else don't do anything
            } else { //Digit is a number
                display.text = textInDisplay + digit
            }
        } else {
            display.text = digit
            userIsTyping = true
        }
    }
    
    //Computed property, simplifies code
    //If we need to get the displayValue, receive it as a double casting of text
    //If we need to set the display value, set it to be the String casting of 
    //the value
    var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = String(newValue)
        }
    }
    
    //create struct of calculator brain, represents model
    private var brain : CalculatorBrain = CalculatorBrain()
    //Green arrow of controller talking to model
    @IBAction func performOperation(_ sender: UIButton) {
        
        //If user was in the middle of typing, accumulate all the numbers that
        //the user typed and set it to be the brain's accumulator
        if userIsTyping {
            brain.setOperand(displayValue)
            userIsTyping = false
            haveDecimal = false
        }
        userIsTyping = false
        //If an operation button from the view was pressed, perform that operation
        //on the brain
        if let symbol = sender.currentTitle {
            brain.performOperation(symbol)
        }
        //result might not be set from brain's property (might be optional)
        if let result = brain.result {
            displayValue = result
        }
    }
    
    
}

