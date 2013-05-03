//
//  UIView+Autolayout.m
//  VFLDemo1
//
//  Created by Kevin on 4/27/13.
//  Copyright (c) 2013 Kevin. All rights reserved.
//

#import "UIView+Autolayout.h"

@implementation UIView (AutoLayout)

+ (id)autolayoutView
{
    UIView *view = [self new];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    return view;
}

@end
