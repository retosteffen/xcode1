//
//  GraphView.h
//  Calculator
//
//  Created by Reto Steffen on 27.07.12.
//
//

#import <UIKit/UIKit.h>

@class GraphView;

@protocol GraphViewDataSource

- (CGFloat)getYValue:(CGFloat)x;
- (NSString *)getProgramName;
@end





@interface GraphView : UIView
@property (nonatomic) CGFloat scale;
@property (nonatomic) CGPoint origin;
- (void)pinch:(UIPinchGestureRecognizer *)gesture;
- (void)pan:(UIPanGestureRecognizer *)gesture;
- (void)tap:(UITapGestureRecognizer *)gesture;
@property (nonatomic, weak) IBOutlet id <GraphViewDataSource> dataSource;


- (void)drawString:(NSString *)text atPoint:(CGPoint)location withAnchor:(int)anchor;
@end
