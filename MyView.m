//
//  MyView.m
//  添金投
//
//  Created by mac on 15/7/8.
//  Copyright (c) 2015年 ApexSoft. All rights reserved.
//

#import "MyView.h"

@implementation MyView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
       // self.font = [UIFont fontWithName:@"Helvetica" size:19];
       // self.textColor = [UIColor blueColor];
    }
    return self;
}

-(void)drawRect:(CGRect)rect
{
    
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //画线
//        UIColor *aColor = [UIColor colorWithRed:0 green:1.0 blue:0 alpha:0];
//    CGContextSetRGBStrokeColor(context, 1.0, 0, 0, 1.0);
//       CGContextSetFillColorWithColor(context, aColor.CGColor);
//    CGContextSetLineWidth(context, 1.0);
//    CGPoint aPoints[5];
//    aPoints[0] =CGPointMake(20, 60);
//    aPoints[1] =CGPointMake(180, 60);
//    aPoints[2] =CGPointMake(180, 30);
//    aPoints[3] =CGPointMake(20, 30);
//    aPoints[4] =CGPointMake(20, 60);
//    CGContextAddLines(context, aPoints, 5);
//    CGContextDrawPath(context, kCGPathStroke); //开始画线
    
    //椭圆
   // CGRect aRect= CGRectMake(1, 1, 150, 90);
   // CGContextSetRGBStrokeColor(context, 0.6, 0.9, 0, 1.0);
   // CGContextSetLineWidth(context, 1.0);
    //   CGContextSetFillColorWithColor(context, aColor.CGColor);
       CGContextAddRect(context, rect); //矩形
   // CGContextAddEllipseInRect(context, aRect); //椭圆
    //CGContextDrawPath(context, kCGPathStroke);
   
    /***************弧线*******************/
   //CGContextAddArcToPoint与CGContextAddArc
  //  void CGContextAddArc(CGContextRef c,CGFloat x, CGFloat y,CGFloat radius,CGFloat startAngle,CGFloat endAngle, int clockwise)
   // x,y为圆点坐标，startAngle为开始的弧度，endAngle为 结束的弧度，clockwise 0为顺时针，1为逆时针。
    
    CGContextBeginPath(context);
    CGContextSetRGBStrokeColor(context, 0, 0, 1, 1);
    CGContextMoveToPoint(context, 10, 10);
    CGContextAddArcToPoint(context, 50, 100, 50, 150, 50);
    CGContextStrokePath(context);
    
    
    
}


@end
