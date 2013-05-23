//
//  MTWeatherViewController.h
//  Rain
//
//  Created by Kevin on 5/21/13.
//  Copyright (c) 2013 Kevin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTLocationViewController.h"

@interface MTWeatherViewController : UIViewController<MTLocationViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *labelLocation;
@property (weak, nonatomic) IBOutlet UIButton *buttonRefresh;
@end
