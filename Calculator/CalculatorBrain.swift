//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Mike Lin on 12/8/17.
//  Copyright © 2017 Mike Lin. All rights reserved.
//

import Foundation




//Structs in Swift are "First Class Citizens"
//Very Similiar to Classes
//Ex: Dictionary
//[Differences]
//No Inheritance,
//Classes live in heap and need pointers, structs are passed around (value-types)
//Structs get a free initializer that auto intiializes all variables
//Methods that changes values of internal members, must mark it mutating



struct CalculatorBrain {
    
    //Internal var, cannot be accessed by outside of struct
    //Accumulator is the number that the calculator is storing and going to use
    //to compute some number
    private var accumulator: Double?
    //Data struct that holds a function and the first operand to apply the function
    //to, when used with perform, it takes a second operand and applys the function
    //to both operands
    private var pendingBinaryOperation: PendingBinaryOperation?
    
    
    //Data structure that holds a function and an operand. When perform is called
    //it takes a second operand and returns the function of the two operands
    private struct PendingBinaryOperation {
        let function: (Double, Double) -> Double
        let firstOperand: Double
        func perform(with secondOperand: Double) -> Double {
            return function(firstOperand, secondOperand)
        }
    }
    //Data structure that holds the type of operation to perform given the
    //associated value specified by it's declaration
    private enum Operation {
        case constant(Double)
        case unaryOperation((Double) -> Double)
        case binaryOperation((Double, Double) -> Double)
        case equals
    }
    
    //Dictionary data structure used to create a table of operations to be used
    //In the calculator. Creates a table that stores a string key representing the
    //operation to use, and the operation to perform with the associated string
    private var operations: Dictionary<String, Operation> = [
        "π" : Operation.constant(Double.pi), //Double.pi
        "e" : Operation.constant(M_E), //M_E,
        "√" : Operation.unaryOperation(sqrt), //sqrt
        "cos" : Operation.unaryOperation(cos), //cos
        "±" : Operation.unaryOperation({ -$0 }),
        "×" : Operation.binaryOperation({ $0 * $1}),
        "÷" : Operation.binaryOperation({ $0 / $1}),
        "+" : Operation.binaryOperation({ $0 + $1}),
        "-" : Operation.binaryOperation({ $0 - $1}),
        "=" : Operation.equals,
        "clear" : Operation.constant(0)
    ]
    
    
    
    
    
    /** 
      * Method that performs an operation based off the string that is found in
      * the parameter. Looks up the string from the operations dictionary and performs
      * that operation 
      */
    mutating func performOperation(_ symbol: String) {
        //check if constant is a symbol in the table
        if let operation = operations[symbol] {
            switch operation {
            case.constant(let value):
                //Set the accumulator to be the value of the constant
                accumulator = value
                break
            case.unaryOperation(let function):
                //Check if accumulator is not nil and if so, apply unaryOperation to it
                if accumulator != nil {
                    accumulator = function(accumulator!)
                }
                break
            case.binaryOperation(let function):
                //Check if accumulator is not nil and if so, store the function and
                //the first operand to the pendingBinaryOperation struct. Reset
                //accumulator to nil to await for the second operand
                if accumulator != nil {
                    pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator!)
                    accumulator = nil
                }
                break
            case.equals:
                performPendingBinaryOperation()
                break
            }
        }
    }
    
    /** 
      * Helper method that evaluates the pendingBinaryOperation data struct. It
      * checks to see if it's contents are not nil, and it checks that the current
      * accumulator state is not nil. If so, then it calls upon the PBO struct to
      * perform it's function with accumulator being the second operand. Returns
      * the accumulator as the result of the function being called 
      */
    mutating private func performPendingBinaryOperation() {
        if pendingBinaryOperation != nil && accumulator != nil {
            accumulator = pendingBinaryOperation!.perform(with: accumulator!)
            pendingBinaryOperation = nil
        }
    }
    
    mutating func setOperand(_ operand: Double) {accumulator = operand}
    
    //read only property
    //Returns the accumulator as a double
    var result: Double? {
        get {
            return accumulator
        }
    }
}
