//
//  UIColor+LightAndDark.m
//  Lua
//
//  Created by Kurry Tran on 12/24/12.
//  Copyright (c) 2012 Lua Technologies. All rights reserved.
//

#import "UIColor+LightAndDark.h"

@implementation UIColor (LightAndDark)
//http://stackoverflow.com/questions/11598043/get-slightly-lighter-and-darker-color-from-uicolor

- (UIColor *)lighterColor:(CGFloat)percent
{
  float h, s, b, a;
  if ([self getHue:&h saturation:&s brightness:&b alpha:&a])
    return [UIColor colorWithHue:h
                      saturation:s
                      brightness:MIN(b * (1+percent), 1.0)
                           alpha:a];
  return nil;
}

- (UIColor *)darkerColor:(CGFloat)percent
{
  float h, s, b, a;
  if ([self getHue:&h saturation:&s brightness:&b alpha:&a])
    return [UIColor colorWithHue:h
                      saturation:s
                      brightness:b * (1-percent)
                           alpha:a];
  return nil;
}
@end
