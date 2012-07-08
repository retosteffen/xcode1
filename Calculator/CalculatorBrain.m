//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Reto Steffen on 28.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorBrain.h"


@interface CalculatorBrain()
@property (nonatomic, strong) NSMutableArray *programStack;
@property (nonatomic, strong) NSDictionary *variableValues;
@end


@implementation CalculatorBrain

@synthesize programStack = _programStack;

- (NSMutableArray *)programStack
{
    if (_programStack == nil) _programStack = [[NSMutableArray alloc] init];
    return _programStack;
}

- (id)program
{
    return [self.programStack copy];
}

@synthesize variableValues=_variableValues;
- (NSDictionary *) variableValues {
   
    
    if (_variableValues == nil) _variableValues = [[NSDictionary alloc] init];
    
    return _variableValues;
}

- (void)addVariableValues:(NSDictionary *)dictionary
{
    self.variableValues=dictionary;
    [[self class] runProgram:self.program usingVariableValues:self.variableValues];
}

+ (NSString *) typeOfOperand:(NSString *)operand {
    
    
    
    if ([operand isEqualToString:@"+"] || [operand isEqualToString:@"-"] || [operand isEqualToString:@"*"] || [operand isEqualToString:@"/"]) {
        return @"2";
        
    }
    if ([operand isEqualToString:@"sin"] || [operand isEqualToString:@"cos"] || [operand isEqualToString:@"sqrt"] || [operand isEqualToString:@"+/-"]) {
        return @"1";
        
    }
    
    return @"0";
    
}


+ (NSString *) descriptionOfTopOfStack:(NSMutableArray *)stack {
    NSString *description=@"";
    
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    
    
    if ([topOfStack isKindOfClass:[NSNumber class]])
    {
        NSNumber *number=topOfStack;
        description=[description stringByAppendingFormat:@"%@",number];
        
    }
    
    else if ([topOfStack isKindOfClass:[NSString class]])
    {
        if ([[self class] typeOfOperand:topOfStack]==@"2"){
            id secondArgument=[self descriptionOfTopOfStack:stack];
            description=[description stringByAppendingFormat:@"(%@ %@ %@)",[self descriptionOfTopOfStack:stack],topOfStack,secondArgument];
            
        }
        else if ([[self class] typeOfOperand:topOfStack]==@"1"){
            description=[description stringByAppendingFormat:@"%@ (%@)",topOfStack,[self descriptionOfTopOfStack:stack]];
            
        }
        else if ([[self class] typeOfOperand:topOfStack]==@"0"){
            description=[description stringByAppendingFormat:@"%@",topOfStack];
            
        }
        
    }
    
    
    
    return description;
    
}


+ (NSString *)descriptionOfProgram:(id)program
{
    
    NSMutableArray *programlist;
    if ([program isKindOfClass:[NSArray class]]) {
        programlist = [program mutableCopy];
    }

   
            
            
       
    NSString *description=[self descriptionOfTopOfStack:programlist];
    
    while (programlist.count) {
        
        description=[NSString stringWithFormat:@"%@,%@",description,[self descriptionOfTopOfStack:programlist]];
    }
  return description;
}


- (void)pushOperand:(double)operand
{
    [self.programStack addObject:[NSNumber numberWithDouble:operand]];
}


- (void) pushVariable:(NSString *)variable
{
    [self.programStack addObject:variable];
}



- (double)performOperation:(NSString *)operation
{
    [self.programStack addObject:operation];
    return [[self class] runProgram:self.program usingVariableValues:self.variableValues];
}

+ (double)popOperandOffProgramStack:(NSMutableArray *)stack
{
    double result = 0;
    
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    
    if ([topOfStack isKindOfClass:[NSNumber class]])
    {
        result = [topOfStack doubleValue];
    }
    else if ([topOfStack isKindOfClass:[NSString class]])
    {
        NSString *operation = topOfStack;
        if ([operation isEqualToString:@"+"]) {
            result = [self popOperandOffProgramStack:stack] +
            [self popOperandOffProgramStack:stack];
        } else if ([@"*" isEqualToString:operation]) {
            result = [self popOperandOffProgramStack:stack] *
            [self popOperandOffProgramStack:stack];
        } else if ([operation isEqualToString:@"-"]) {
            double subtrahend = [self popOperandOffProgramStack:stack];
            result = [self popOperandOffProgramStack:stack] - subtrahend;
        } else if ([operation isEqualToString:@"/"]) {
            double divisor = [self popOperandOffProgramStack:stack];
            if (divisor) result = [self popOperandOffProgramStack:stack] / divisor;
        }
        else if([@"sin" isEqualToString:operation]) {//in rads
            
            result=sin([self popOperandOffProgramStack:stack]);
        }
        else if([@"cos" isEqualToString:operation]) {//in rads
            result=cos([self popOperandOffProgramStack:stack]);
        }
        else if([@"sqrt" isEqualToString:operation]) {
            result=sqrt([self popOperandOffProgramStack:stack]);
        }
        else if([@"π" isEqualToString:operation]) {
            result=M_PI;
        }
        else if([@"+/-" isEqualToString:operation]) {
            result=-1*([self popOperandOffProgramStack:stack]);
        }
    }
    
    return result;
}

+ (double)runProgram:(id)program
{
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    return [self popOperandOffProgramStack:stack];
}


+ (double) runProgram:(id)program usingVariableValues:(NSDictionary *)variableValues
{
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
   
    for (int i=0;i<stack.count;i++) {
        id obj=[stack objectAtIndex:i];
    
        if ([variableValues objectForKey:obj]){
            id value=[variableValues objectForKey:obj];
            [stack replaceObjectAtIndex:i withObject:value];
        }
        
        
    }
 
    
    return [self runProgram:stack];
}



- (void) clearAll {
        [self.programStack removeAllObjects];
      NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:0],@"x",[NSNumber numberWithInt:0],@"a",[NSNumber numberWithInt:0],@"b",nil];
    [self addVariableValues:dict];
    
}


- (NSString *) description {
    return [NSString stringWithFormat:@"stack=%@",self.programStack];
}



+ (NSSet *) variablesUsedInProgram:(id)program {

    
    return nil;
    
}


@end
