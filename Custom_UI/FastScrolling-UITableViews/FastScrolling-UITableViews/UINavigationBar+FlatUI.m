//
//  UINavigationBar+FlatUI.m
//  FastScrolling-UITableViews
//
//  Created by Kurry L Tran on 6/26/13.
//  Copyright (c) 2013 Kurry L Tran. All rights reserved.
//

#import "UINavigationBar+FlatUI.h"
#import "UIImage+FlatUI.h"

@implementation UINavigationBar (FlatUI)

- (void) configureFlatNavigationBarWithColor:(UIColor *)color {
  [self setBackgroundImage:[UIImage imageWithColor:color cornerRadius:0]
             forBarMetrics:UIBarMetricsDefault & UIBarMetricsLandscapePhone];
  NSMutableDictionary *titleTextAttributes = [[self titleTextAttributes] mutableCopy];
  if (!titleTextAttributes) {
    titleTextAttributes = [NSMutableDictionary dictionary];
  }
  [titleTextAttributes setValue:[UIColor clearColor] forKey:UITextAttributeTextShadowColor];
  [titleTextAttributes setValue:[NSValue valueWithUIOffset:UIOffsetMake(0, 0)] forKey:UITextAttributeTextShadowOffset];
  [self setTitleTextAttributes:titleTextAttributes];
  if([self respondsToSelector:@selector(setShadowImage:)])
  {
    [self setShadowImage:[UIImage imageWithColor:[UIColor clearColor] cornerRadius:0]];
  }
}


@end
