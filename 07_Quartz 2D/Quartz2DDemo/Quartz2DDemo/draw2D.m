//
//  draw2D.m
//  Quartz2DDemo
//
//  Created by Kevin on 5/4/13.
//  Copyright (c) 2013 Kevin. All rights reserved.
//

#import "draw2D.h"

@implementation draw2D

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    //[self drawLine];
    //[self drawPath];
    //[self drawRectangle];
    //[self drawCircle];
    [self drawPathWithColor];
}

- (void)drawLine
{
    //    CGContextRef context = UIGraphicsGetCurrentContext();
    //    CGContextSetLineWidth(context, 5.0);
    //    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    //    CGFloat components[] = {0.0, 0.0, 1.0, 1.0};
    //    CGColorRef color = CGColorCreate(colorSpace, components);
    //    CGContextSetStrokeColorWithColor(context, color);
    //    CGContextMoveToPoint(context, 0, 0);
    //    CGContextAddLineToPoint(context, 300, 400);
    //    CGContextStrokePath(context);
    //    CGColorSpaceRelease(colorSpace);
    //    CGColorRelease(color);
    
    // Simple method
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 5.0);
    CGContextSetStrokeColorWithColor(context, [UIColor blueColor].CGColor);
    CGContextMoveToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, 300, 400);
    CGContextStrokePath(context);
}

- (void)drawPath
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 5.0);
    CGContextSetStrokeColorWithColor(context, [UIColor blueColor].CGColor);
    CGContextMoveToPoint(context, 100, 100);
    CGContextAddLineToPoint(context, 150, 150);
    CGContextAddLineToPoint(context, 100, 200);
    CGContextAddLineToPoint(context, 50, 150);
    CGContextAddLineToPoint(context, 100, 100);
    CGContextStrokePath(context);
}

- (void)drawRectangle
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 5.0);
    CGContextSetStrokeColorWithColor(context, [UIColor blueColor].CGColor);
    CGRect rect = CGRectMake(60, 170, 200, 80);
    CGContextAddRect(context, rect);
    CGContextStrokePath(context);
}

- (void)drawCircle
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 5.0);
    CGContextSetStrokeColorWithColor(context, [UIColor blueColor].CGColor);
    CGRect rect = CGRectMake(60, 170, 200, 80);
    CGContextAddEllipseInRect(context, rect);
    CGContextStrokePath(context);
}

- (void)drawPathWithColor
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(context, 100, 100);
    CGContextAddLineToPoint(context, 150, 150);
    CGContextAddLineToPoint(context, 100, 200);
    CGContextAddLineToPoint(context, 50, 150);
    CGContextAddLineToPoint(context, 100, 100);
    CGContextSetFillColorWithColor(context,[UIColor redColor].CGColor);
    CGContextFillPath(context);
}


@end
