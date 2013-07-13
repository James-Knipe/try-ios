//
//  KTTableViewCell.m
//  FastScrolling-UITableViews
//
//  Created by Kurry Tran on 6/27/13.
//  Copyright (c) 2013 Kurry L Tran. All rights reserved.
//

#import "KTTableViewCell.h"

@implementation KTTableViewCell

- (void)setTitle:(NSString *)title subTitle:(NSString *)subtitle image:(UIImage *)image
{
    _title = title;
    _subTitle = subtitle;
    _image = image;
    [self setNeedsDisplay];
}

-(void) drawContentView:(CGRect)r
{
    static UIColor *textColor;
    textColor = [UIColor blackColor];
    static UIColor *borderColor;
    borderColor = [UIColor colorWithRed:200.0f/255.0f green:200.0f/255.0f blue:200.0f/255.0f alpha:1.0f];
    static UIColor *selectedColor;
    selectedColor = [UIColor colorWithRed:212.0f/255.0f green:212.0f/255.0f blue:212.0f/255.0f alpha:1.0f];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if(self.highlighted || self.selected)
	{
        r.origin.y -= 1.0f;
        r.size.height += 1.0f;
        CGContextSetFillColorWithColor(context, selectedColor.CGColor);
		CGContextFillRect(context, CGRectMake(0, 0, CGRectGetWidth(r), CGRectGetMaxY(r)));
        CGContextSaveGState(context);
    }
	else
	{
		CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
		CGContextFillRect(context, CGRectMake(0, 0, r.size.width, r.size.height));
        CGContextSaveGState(context);
        
        CGContextMoveToPoint(context, CGRectGetMinX(r), 0);
        CGContextAddLineToPoint(context, CGRectGetMaxX(r), 0);
        CGContextSetStrokeColorWithColor(context, borderColor.CGColor);
        CGContextSetLineWidth(context, 1);
        CGContextStrokePath(context);
        CGContextRestoreGState(context);
        
        CGContextSaveGState(context);
        
        CGContextMoveToPoint(context, CGRectGetMinX(r), CGRectGetMaxY(r));
        CGContextAddLineToPoint(context, CGRectGetMaxX(r), CGRectGetMaxY(r));
        CGContextSetStrokeColorWithColor(context, borderColor.CGColor);
        CGContextSetLineWidth(context, 1);
        CGContextStrokePath(context);
        CGContextRestoreGState(context);
        [_image drawInRect:CGRectMake(5, 5, 45, 45)];
	}

    [textColor set];
    [_title drawAtPoint:CGPointMake(65.0f, 7.0f)
               forWidth:200
               withFont:[UIFont boldSystemFontOfSize:17]
               fontSize:17
          lineBreakMode:NSLineBreakByTruncatingTail
     baselineAdjustment:UIBaselineAdjustmentAlignCenters];
    
    [_subTitle drawAtPoint:CGPointMake(65.0f, 28.0f)
                  forWidth:200
                  withFont:[UIFont systemFontOfSize:16.0f]
                  fontSize:16
             lineBreakMode:NSLineBreakByTruncatingTail
        baselineAdjustment:UIBaselineAdjustmentAlignCenters];
 
}
@end
