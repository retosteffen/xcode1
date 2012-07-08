//
//  CalculatorBrain.h
//  Calculator
//
//  Created by Reto Steffen on 28.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject

- (void) pushOperand: (double) operand;
- (double) performOperation: (NSString *)operation;
- (void) clearAll;

- (void)pushVariable: (NSString *) variable;
- (void)addVariableValues: (NSDictionary *)dictionary;

+ (NSString *) typeOfOperand:(NSString *) operand ;
-(void)popLastItem;

+ (NSString *) descriptionOfTopOfStack:(NSMutableArray *)stack;

@property (nonatomic, readonly) id program;

+ (NSString *)descriptionOfProgram:(id)program;
+ (double)runProgram:(id)program;
+ (double)runProgram:(id)program usingVariableValues:(NSDictionary *)variableValues;
+ (NSSet *) variablesUsedInProgram:(id)program;
@end
