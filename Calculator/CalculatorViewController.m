//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Reto Steffen on 28.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"

@interface CalculatorViewController ()

@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic) BOOL userTypedAFloatingPoint;
@property (nonatomic,strong) CalculatorBrain *brain;

@end

@implementation CalculatorViewController
@synthesize display;
@synthesize allOperationsDisplay;
@synthesize variablesUsedDisplay;
@synthesize userIsInTheMiddleOfEnteringANumber;
@synthesize brain=_brain;
@synthesize userTypedAFloatingPoint;

- (CalculatorBrain *)brain {
    if (!_brain) _brain = [[CalculatorBrain alloc]init];
    return _brain;
}

//not used anymore
- (void) deleteEqualSignIfExist {
    NSRange range=[self.allOperationsDisplay.text rangeOfString:@"="];
    if (range.location==NSNotFound) {}
    else {
        
        self.allOperationsDisplay.text=[self.allOperationsDisplay.text substringToIndex:range.location];
        self.allOperationsDisplay.text=[self.allOperationsDisplay.text stringByAppendingString:@" "];
    }
}


- (IBAction)digitPressed:(UIButton *)sender {
    
    [self deleteEqualSignIfExist];
    
    NSString *digit=sender.currentTitle;
    if (self.userIsInTheMiddleOfEnteringANumber) {
        self.display.text=[self.display.text stringByAppendingString:digit];
        
    }
    else {
        self.display.text=digit;
        self.userIsInTheMiddleOfEnteringANumber=YES;
        
        
    }
    
}


- (IBAction)enterPressed {
    [self deleteEqualSignIfExist];
    [self.brain pushOperand:[self.display.text doubleValue]];
    self.userIsInTheMiddleOfEnteringANumber=NO;
    self.userTypedAFloatingPoint=NO;
    
    self.allOperationsDisplay.text=[CalculatorBrain descriptionOfProgram:self.brain.program];
    
    
    
}


- (IBAction)operationPressed:(UIButton *)sender {
    [self deleteEqualSignIfExist];
    if (self.userIsInTheMiddleOfEnteringANumber) {
        [self enterPressed];
    }
    NSString *operation=[sender currentTitle];
    double result= [self.brain performOperation:operation];
    self.display.text=[NSString stringWithFormat:@"%g",result];
    
    
    self.allOperationsDisplay.text=[CalculatorBrain descriptionOfProgram:self.brain.program];
    
}


- (IBAction)plusMinusPressed:(UIButton *)sender {
    if (self.userTypedAFloatingPoint) {
        [self digitPressed:sender];
    }
    else {
        [self enterPressed];
        [self operationPressed:sender];
        
    }
}


- (IBAction)floatingPointPressed: (UIButton *)sender {
    if (!userTypedAFloatingPoint) {
        userTypedAFloatingPoint=YES;
        [self digitPressed:sender];
    }
}


- (IBAction)backspacePressed {
    if (self.userIsInTheMiddleOfEnteringANumber) {
        
        NSUInteger length=self.display.text.length;
        
        NSRange range=[self.display.text rangeOfString:@"."];
        if (length-1==range.location) {
            self.userTypedAFloatingPoint=NO;  
        }
        
        if ((int)length-1<0){}
        else if ((int) length-1==0) {
            self.display.text=[self.display.text substringToIndex:length-1];
            self.display.text=[NSString stringWithFormat:@"%g",[CalculatorBrain runProgram:self.brain.program]];
            self.userIsInTheMiddleOfEnteringANumber=NO;
        }
        else {
            self.display.text=[self.display.text substringToIndex:length-1];
        }
    }
    else {
        
        
        
        [self.brain popLastItem];
        self.allOperationsDisplay.text=[CalculatorBrain descriptionOfProgram:self.brain.program];
        self.display.text=[NSString stringWithFormat:@"%g",[CalculatorBrain runProgram:self.brain.program]];
        
    }
}


- (IBAction)clearAllPressed {
    
    [self.brain clearAll];
    self.display.text=@"0";
    self.allOperationsDisplay.text=@"";
    self.variablesUsedDisplay.text=@"";
}

- (IBAction)variablePressed:(UIButton *)sender {
    if (self.userIsInTheMiddleOfEnteringANumber) {
        [self.brain pushOperand:[self.display.text doubleValue]];
        
        
        self.userIsInTheMiddleOfEnteringANumber=NO;
    }
    
    
    NSString *variable=[sender currentTitle];
    [self.brain pushVariable:variable];
    
    self.allOperationsDisplay.text=[CalculatorBrain descriptionOfProgram:self.brain.program];
    self.variablesUsedDisplay.text=[self.brain showVariablesUsedInProgram:self.brain.program];
}

- (IBAction)testPressed:(UIButton *)sender {
    NSDictionary *dict;
    if ([@"Test 1" isEqualToString:sender.currentTitle]) {
        dict=[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithDouble:1.1],@"x",[NSNumber numberWithInt:2],@"a",[NSNumber numberWithInt:3],@"b",nil];
    }
    else if ([@"Test 2" isEqualToString:sender.currentTitle]) {
        dict=[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:4],@"x",[NSNumber numberWithInt:10],@"a",[NSNumber numberWithInt:0],@"b",nil];    
    }
    else if ([@"Test 3" isEqualToString:sender.currentTitle]) {
        dict=nil; 
    }
    
    [self.brain addVariableValues:dict];
    self.display.text=[NSString stringWithFormat:@"%g",[CalculatorBrain runProgram:self.brain.program usingVariableValues:dict]];
    self.allOperationsDisplay.text=[CalculatorBrain descriptionOfProgram:self.brain.program];
    
    self.variablesUsedDisplay.text=[self.brain showVariablesUsedInProgram:self.brain.program];
    
    
}





- (void)viewDidUnload {
    [self setAllOperationsDisplay:nil];
    [self setVariablesUsedDisplay:nil];
    [super viewDidUnload];
}
@end
