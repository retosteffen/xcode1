//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Reto Steffen on 28.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorBrain.h"


@interface CalculatorBrain()
@property (nonatomic, strong) NSMutableArray *operandStack;

@end


@implementation CalculatorBrain

@synthesize operandStack=_operandStack;

- (NSMutableArray *) operandStack {
    if (!_operandStack) {
        _operandStack=[[NSMutableArray alloc] init];
    }
    return _operandStack;
}



- (void) pushOperand:(double)operand {
    [self.operandStack addObject:[NSNumber numberWithDouble:operand]];
}


- (double) popOperand {

    NSNumber *operandObject=[self.operandStack lastObject];
    if (operandObject) [self.operandStack removeLastObject];
    return [operandObject doubleValue];
    
}

- (void) clearAll {
        [self.operandStack removeAllObjects];
    
}



- (double) performOperation:(NSString *)operation {
    double result=0;
    
    if ([operation isEqualToString:@"+"]) {
        result=[self popOperand]+[self popOperand];
    }
    else if([@"*" isEqualToString:operation]) {
        result=[self popOperand]*[self popOperand];
    }
    else if([@"-" isEqualToString:operation]) {
        double subtrahend=[self popOperand];
        result=[self popOperand]-subtrahend;
    }
    else if([@"/" isEqualToString:operation]) {
        double divisor=[self popOperand];
        if (divisor) result=[self popOperand]/divisor;
    }
    else if([@"sin" isEqualToString:operation]) {//in rads
        
        result=sin([self popOperand]);
    }
    else if([@"cos" isEqualToString:operation]) {//in rads
         result=cos([self popOperand]);
    }
    else if([@"sqrt" isEqualToString:operation]) {
        result=sqrt([self popOperand]);
    }
    else if([@"π" isEqualToString:operation]) {
        result=M_PI;
    }
    else if([@"+/-" isEqualToString:operation]) {
         result=-1*([self popOperand]);
    }

    [self pushOperand:result];
    return result;
}


- (NSString *) description {
    return [NSString stringWithFormat:@"stack=%@",self.operandStack];
}

@end
