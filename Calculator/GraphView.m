//
//  GraphView.m
//  Calculator
//
//  Created by Reto Steffen on 27.07.12.
//
//

#import "GraphView.h"
#import "AxesDrawer.h"


@implementation GraphView
@synthesize dataSource = _dataSource;

@synthesize scale = _scale;
@synthesize origin=_origin;
#define DEFAULT_SCALE 50.0


#define HORIZONTAL_TEXT_MARGIN 6
#define VERTICAL_TEXT_MARGIN 3
- (void)drawString:(NSString *)text atPoint:(CGPoint)location withAnchor:(int)anchor
{
    if ([text length])
    {
        UIFont *font = [UIFont systemFontOfSize:12.0];
        
        CGRect textRect;
        textRect.size = [text sizeWithFont:font];
        textRect.origin.x = location.x - textRect.size.width / 2;
        textRect.origin.y = location.y - textRect.size.height / 2;
        
        switch (anchor) {
            case 0: textRect.origin.y += textRect.size.height / 2 + VERTICAL_TEXT_MARGIN; break;
            case 1: textRect.origin.x += textRect.size.width / 2+ HORIZONTAL_TEXT_MARGIN; break;
            case 2: textRect.origin.y -= textRect.size.height / 2 + VERTICAL_TEXT_MARGIN; break;
            case 3: textRect.origin.x -= textRect.size.width / 2+ HORIZONTAL_TEXT_MARGIN; break;
        }
        
        [text drawInRect:textRect withFont:font];
    }
}

- (CGFloat)scale
{
    if (!_scale) {
        return DEFAULT_SCALE; // don't allow zero scale
    } else {
        return _scale;
    }
}

- (void)setScale:(CGFloat)scale
{
    if (scale != _scale) {
        _scale = scale;
        [self setNeedsDisplay]; // any time our scale changes, call for redraw
    }
}


- (void)pinch:(UIPinchGestureRecognizer *)gesture
{
    if ((gesture.state == UIGestureRecognizerStateChanged) ||
        (gesture.state == UIGestureRecognizerStateEnded)) {
        self.scale *= gesture.scale; // adjust our scale
        gesture.scale = 1;           // reset gestures scale to 1 (so future changes are incremental, not cumulative)
        
        
        
        
        [[NSUserDefaults standardUserDefaults]
         registerDefaults:
         [[NSDictionary alloc]initWithObjectsAndKeys:
          [NSNumber numberWithFloat:self.scale],
          [[self.dataSource getProgramName] stringByAppendingString:@"_scale"], nil]];
        
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
}
- (void)pan:(UIPanGestureRecognizer *)gesture
{
    if ((gesture.state == UIGestureRecognizerStateChanged) ||
        (gesture.state == UIGestureRecognizerStateEnded)) {
    CGPoint translation = [gesture translationInView:self];
        CGPoint newOrigin;
        newOrigin.x = self.origin.x + translation.x;
        newOrigin.y = self.origin.y + translation.y;
        self.origin = newOrigin;
        [gesture setTranslation:CGPointZero inView:self];
        [self setNeedsDisplay];
        
        
        [[NSUserDefaults standardUserDefaults]
         registerDefaults:
         [[NSDictionary alloc]initWithObjectsAndKeys:
          [NSNumber numberWithFloat:self.origin.x],
          [[self.dataSource getProgramName] stringByAppendingString:@"_origin.x"], nil]];
        
        [[NSUserDefaults standardUserDefaults]
         registerDefaults:
         [[NSDictionary alloc]initWithObjectsAndKeys:
          [NSNumber numberWithFloat:self.origin.y],
          [[self.dataSource getProgramName] stringByAppendingString:@"_origin.y"], nil]];
        
        [[NSUserDefaults standardUserDefaults]synchronize];
        
    }
}

- (void)tap:(UITapGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateEnded){
        if (gesture.numberOfTapsRequired=3){
        CGPoint newOrigin = [gesture locationInView:self];
     
        self.origin = newOrigin;
        
        [self setNeedsDisplay];
            
            [[NSUserDefaults standardUserDefaults]
             registerDefaults:
             [[NSDictionary alloc]initWithObjectsAndKeys:
              [NSNumber numberWithFloat:self.origin.x],
              [[self.dataSource getProgramName] stringByAppendingString:@"_origin.x"], nil]];
            
            [[NSUserDefaults standardUserDefaults]
             registerDefaults:
             [[NSDictionary alloc]initWithObjectsAndKeys:
              [NSNumber numberWithFloat:self.origin.y],
              [[self.dataSource getProgramName] stringByAppendingString:@"_origin.y"], nil]];
            
            [[NSUserDefaults standardUserDefaults]synchronize];
    }
    }
    
}

- (void)setup
{
    CGPoint newOrigin;
    //newOrigin.x = [[NSUserDefaults standardUserDefaults]floatForKey:[[self.dataSource getProgramName] stringByAppendingString:@"_origin.x"]];
    //newOrigin.y = [[NSUserDefaults standardUserDefaults]floatForKey:[[self.dataSource getProgramName] stringByAppendingString:@"_origin.y"]];
    //self.origin = newOrigin;

  
    //self.scale = [[NSUserDefaults standardUserDefaults]floatForKey:[[self.dataSource getProgramName] stringByAppendingString:@"_scale"]];
   
    
    
    self.contentMode = UIViewContentModeRedraw; // if our bounds changes, redraw ourselves
}

- (void)awakeFromNib
{
    [self setup]; // get initialized when we come out of a storyboard
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup]; // get initialized if someone uses alloc/initWithFrame: to create us

    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGPoint midPoint; // center of our bounds in our coordinate system
    midPoint.x = self.bounds.origin.x + self.bounds.size.width/2;
    midPoint.y = self.bounds.origin.y + self.bounds.size.height/2;
    
    if (self.origin.x==0 && self.origin.y==0) {
    CGPoint newOrigin;
    newOrigin.x=midPoint.x;
    newOrigin.y=midPoint.y;
        self.origin=newOrigin;
    }
       
    CGContextSetLineWidth(context, 1.0);
    [[UIColor blackColor] setStroke];
    
    [AxesDrawer drawAxesInRect:self.bounds originAtPoint:self.origin scale:self.scale];
    
[[UIColor blueColor] setStroke];
    CGPoint graph;
 
    BOOL started=NO;
    //BOOL dotDrawing=NO;
    int x;
    int y;
    for (int i=0;i<=(self.bounds.size.width*self.contentScaleFactor);i++) {
        
       CGFloat calculatedX=i;
        CGFloat valueForX=(calculatedX/self.contentScaleFactor-self.origin.x)/self.scale;
        CGFloat calculatedY=-[self.dataSource getYValue:valueForX];
        
        graph.x=(i/self.contentScaleFactor);
        graph.y=(calculatedY*self.scale)+self.origin.y;
          
        if ((graph.x>self.bounds.size.width || graph.x<0) || (graph.y>self.bounds.size.height || graph.y<0))
        {
            //NSLog(@"out of bounds x:%f y:%f",graph.x,graph.y);
            started=NO;
        }
        else
        {
            /* not used if started=NO on line graph, which makes next point in bounds a new start of line
        if (dotDrawing) {
            CGRect rect = CGRectMake(graph.x, graph.y, 1/self.contentScaleFactor, 1/self.contentScaleFactor);
            CGContextFillRect(context, rect);
        }
        else {
             */
        CGContextBeginPath(context);
        if (!started) {
        CGContextMoveToPoint(context,graph.x,graph.y);
            started=YES;
        }
        else {
        CGContextMoveToPoint(context,x,y);
        CGContextAddLineToPoint(context, graph.x, graph.y);
        }
        
        CGContextStrokePath(context);
        x=graph.x;
        y=graph.y;
      //  }
    }
        
    }

    
    
    NSString *string=[self.dataSource getProgramName];
    CGPoint point;
    point.x=self.origin.x+20;
    point.y=20;
    
    [self drawString:[NSString stringWithFormat:@"%@",string] atPoint:point withAnchor:1];
    
    


    
}






@end
