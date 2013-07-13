//
//  UIColor+LightAndDark.h
//  Lua
//
//  Created by Kurry Tran on 12/24/12.
//  Copyright (c) 2012 Lua Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (LightAndDark)
- (UIColor *)lighterColor:(CGFloat)percent;
- (UIColor *)darkerColor:(CGFloat)percent;
@end
