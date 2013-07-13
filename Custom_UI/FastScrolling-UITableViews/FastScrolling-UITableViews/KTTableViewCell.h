//
//  KTTableViewCell.h
//  FastScrolling-UITableViews
//
//  Created by Kurry Tran on 6/27/13.
//  Copyright (c) 2013 Kurry L Tran. All rights reserved.
//

#import "ABTableViewCell.h"

@interface KTTableViewCell : ABTableViewCell
{
    NSString *_title;
    NSString *_subTitle;
    UIImage *_image;
}
- (void)setTitle:(NSString *)title subTitle:(NSString *)subtitle image:(UIImage *)image;
@end
