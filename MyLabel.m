//
//  MyLabel.m
//  添金投
//
//  Created by mac on 15/7/8.
//  Copyright (c) 2015年 ApexSoft. All rights reserved.
//

#import "MyLabel.h"

@implementation MyLabel

- (id)initWithFrame:(CGRect)frame {
self = [super initWithFrame:frame];
if (self) {
    self.backgroundColor = [UIColor clearColor];
    self.font = [UIFont fontWithName:@"Helvetica" size:19];
    self.textColor = [UIColor blueColor];
}
return self;
}
/*
- (void)drawRect:(CGRect)rect {
    
    //Get the current drawing context
    CGContextRef context = UIGraphicsGetCurrentContext();
    //Set the line color and width
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0.784 green:0.675 blue:0.576 alpha:1.0].CGColor);
    CGContextSetLineWidth(context, 1.0f);
    //Start a new Path
    CGContextBeginPath(context);
    
    //Find the number of lines in our textView + add a bit more height to draw lines in the empty part of the view
    NSUInteger numberOfLines = (self.frame.size.height + self.bounds.size.height) / self.font.lineHeight;
    
    //Set the line offset from the baseline. (I'm sure there's a concrete way to calculate this.)
    CGFloat baselineOffset = 3.5f;
    
    //iterate over numberOfLines and draw each line
    for (int x = 0; x < numberOfLines; x++) {
        //0.5f offset lines up line with pixel boundary
        CGContextMoveToPoint(context, self.bounds.origin.x, self.font.lineHeight*x + 0.5f + baselineOffset);
        CGContextAddLineToPoint(context, self.bounds.size.width, self.font.lineHeight*x + 0.5f + baselineOffset);
        
    }
    
    //Close our Path and Stroke (draw) it
    CGContextClosePath(context);
    CGContextStrokePath(context);
}

*/


- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
   // 画一个正方形图形 没有边框,写文字
    
   // CGContextSetLineWidth(context, 1.0);
   // CGContextSetRGBFillColor(context, 0, 0.25, 0, 0.5);
    //CGContextFillRect(context, CGRectMake(2, 2, 200, 36));
    //[@"fangyp" drawInRect:CGRectMake(40, 8, 80, 20) withFont:self.font];
   // CGContextStrokePath(context);
    
    
   // 画一条线
   // CGContextSetRGBStrokeColor(context, 0.5, 0.5, 0.5, 0.5);//线条颜色
   // CGContextMoveToPoint(context, 20, 20);
   // CGContextAddLineToPoint(context, 180,20);
   // CGContextSetLineWidth(context, 1.0);
    //CGContextStrokePath(context);
  //  画正方形边框
//    CGContextSetRGBStrokeColor(context, 1, 1.0, 1.0, 1.0);
//    CGContextSetLineWidth(context, 1.0);
//    CGContextAddRect(context, CGRectMake(2, 2, 100, 36));
//    CGContextStrokePath(context);
    
    
   // 画方形背景颜色
    CGContextTranslateCTM(context, 0.0f, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0f, -1.0f);
    UIGraphicsPushContext(context);
    CGContextSetLineWidth(context,320);
    CGContextSetRGBStrokeColor(context, 250.0/255, 250.0/255, 210.0/255, 1.0);
    CGContextStrokeRect(context, CGRectMake(0, 0, 200, 40));
    UIGraphicsPopContext();
    
    
    
}

@end
