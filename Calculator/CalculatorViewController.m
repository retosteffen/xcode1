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
@synthesize allOperationsDisplay;//ugly
@synthesize userIsInTheMiddleOfEnteringANumber;
@synthesize brain=_brain;
@synthesize userTypedAFloatingPoint;

- (CalculatorBrain *)brain {
    if (!_brain) _brain = [[CalculatorBrain alloc]init];
    return _brain;
}


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
    
   
    self.allOperationsDisplay.text=[self.allOperationsDisplay.text stringByAppendingString:self.display.text];
     self.allOperationsDisplay.text=[self.allOperationsDisplay.text stringByAppendingString:@" "];
    
}


- (IBAction)operationPressed:(UIButton *)sender {
    [self deleteEqualSignIfExist];
    if (self.userIsInTheMiddleOfEnteringANumber) {
        [self enterPressed];
    }
    NSString *operation=[sender currentTitle];
    double result= [self.brain performOperation:operation];
    self.display.text=[NSString stringWithFormat:@"%g",result];
    
   
    self.allOperationsDisplay.text=[self.allOperationsDisplay.text stringByAppendingString:operation];
     self.allOperationsDisplay.text=[self.allOperationsDisplay.text stringByAppendingString:@" "];
    self.allOperationsDisplay.text=[self.allOperationsDisplay.text stringByAppendingString:@"="];
    
    
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
        if ((int)length-1<0){}
        else if ((int) length-1==0) {
            self.display.text=[self.display.text substringToIndex:length-1];
            self.display.text=@"0";
            self.userIsInTheMiddleOfEnteringANumber=NO;
        }
        else {
            self.display.text=[self.display.text substringToIndex:length-1];
        }
    }
}


- (IBAction)clearAllPressed {
    
    [self.brain clearAll];
    self.display.text=@"0";
    self.allOperationsDisplay.text=@"";
}


- (void)viewDidUnload {
    [self setAllOperationsDisplay:nil];
    [super viewDidUnload];
}
@end
