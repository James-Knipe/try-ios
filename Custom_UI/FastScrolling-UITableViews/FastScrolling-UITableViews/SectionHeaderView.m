//
//  SectionHeaderView.m
//  FastScrolling-UITableViews
//
//  Created by Kurry L Tran on 6/26/13.
//  Copyright (c) 2013 Kurry L Tran. All rights reserved.
//

#import "SectionHeaderView.h"
#import "UIColor+LightAndDark.h"
#import <QuartzCore/QuartzCore.h>

@implementation SectionHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setTitle:(NSString *)title subTitle:(NSString *)subTitle
{
  _title = title;
  _subTitle = subTitle;
  [self setNeedsDisplay];
}

- (void)setTitle:(NSString *)title subTitle:(NSString *)subTitle image:(UIImage *)image
{
    _title = title;
    _subTitle = subTitle;
    _image = image;
    [self setNeedsDisplay];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
  CAGradientLayer *gradientLayer = [CAGradientLayer layer];
  [gradientLayer setFrame:rect];
  NSArray *colors = [NSArray arrayWithObjects:
                     (id)[[UIColor whiteColor] CGColor],
                     (id)[[[UIColor blackColor] colorWithAlphaComponent:1.0f] CGColor],
                     nil];
  gradientLayer.colors = colors;
  gradientLayer.opacity = 0.09;
  [self.layer addSublayer:gradientLayer];
  
  float r = (float)rand()/(float)RAND_MAX;
  float g = (float)rand()/(float)RAND_MAX;
  float b = (float)rand()/(float)RAND_MAX;

  UIColor *baseColor = [UIColor colorWithRed:r green:g blue:b alpha:1.0f];
  UIColor *topBorderColor = [baseColor lighterColor:0.20];
  UIColor *bottomBorderColor = [baseColor darkerColor:0.20];
  
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextSetFillColorWithColor(context, baseColor.CGColor);
  CGContextFillRect(context, CGRectMake(0, 0, self.frame.size.width, self.frame.size.height));
  CGContextSaveGState(context);
  
  CGContextMoveToPoint(context, CGRectGetMinX(rect), 0);
  CGContextAddLineToPoint(context, CGRectGetMaxX(rect), 0);
  CGContextSetStrokeColorWithColor(context, topBorderColor.CGColor);
  CGContextSetLineWidth(context, 1);
  CGContextStrokePath(context);
  CGContextRestoreGState(context);
  
  CGContextSaveGState(context);

  CGContextMoveToPoint(context, CGRectGetMinX(rect), CGRectGetMaxY(rect));
  CGContextAddLineToPoint(context, CGRectGetMaxX(rect), CGRectGetMaxY(rect));
  CGContextSetStrokeColorWithColor(context, bottomBorderColor.CGColor);
  CGContextSetLineWidth(context, 1);
  CGContextStrokePath(context);
  CGContextRestoreGState(context);
  
  CGRect titleLabelFrame = self.bounds;
  titleLabelFrame.origin.x = 69.0;
  titleLabelFrame.origin.y = 8.0;
  
  static UIColor *titleColor;
  titleColor = [UIColor whiteColor];
  static UIColor *subTitleColor;
  subTitleColor = [UIColor whiteColor];
  [titleColor set];
  CGContextSaveGState(context);
  context = UIGraphicsGetCurrentContext();
  CGContextSetBlendMode(context, kCGBlendModeNormal);
  
  [_title drawAtPoint:CGPointMake(titleLabelFrame.origin.x, titleLabelFrame.origin.y)
            forWidth:200
            withFont:[UIFont boldSystemFontOfSize:17]
            fontSize:17
       lineBreakMode:NSLineBreakByTruncatingTail
  baselineAdjustment:UIBaselineAdjustmentAlignCenters];
  
  [subTitleColor set];
  [_subTitle drawAtPoint:CGPointMake(69, 25)
               forWidth:200
               withFont:[UIFont systemFontOfSize:13.0]
               fontSize:13
          lineBreakMode:NSLineBreakByTruncatingTail
     baselineAdjustment:UIBaselineAdjustmentAlignCenters];
    
    [_image drawInRect:CGRectMake(10.0, 10.0, 30.0, 28.0)];
  
}


@end
