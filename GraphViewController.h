//
//  GraphViewController.h
//  Calculator
//
//  Created by Reto Steffen on 27.07.12.
//
//

#import <UIKit/UIKit.h>
#import "CalculatorBrain.h"

@interface GraphViewController : UIViewController

@property (nonatomic, strong) CalculatorBrain *brain;

- (void) setBrain:(CalculatorBrain *)brain;
- (CGFloat) getYValue:(CGFloat)XValue;
- (NSString *)getProgramName;
@end
