//
//  SectionHeaderView.h
//  FastScrolling-UITableViews
//
//  Created by Kurry L Tran on 6/26/13.
//  Copyright (c) 2013 Kurry L Tran. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SectionHeaderView : UIView
{
    NSString *_title;
    NSString *_subTitle;
    UIImage *_image;
}
- (void)setTitle:(NSString *)title subTitle:(NSString *)subTitle;
- (void)setTitle:(NSString *)title subTitle:(NSString *)subTitle image:(UIImage *)image;
@end
