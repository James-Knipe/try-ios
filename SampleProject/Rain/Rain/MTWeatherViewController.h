//
//  MTWeatherViewController.h
//  Rain
//
//  Created by Bart Jacobs on 10/05/13.
//  Copyright (c) 2013 Mobile Tuts. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MTLocationsViewController.h"

@interface MTWeatherViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, MTLocationsViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *buttonLocation;
@property (weak, nonatomic) IBOutlet UIButton *buttonRefresh;

@property (weak, nonatomic) IBOutlet UILabel *labelDate;
@property (weak, nonatomic) IBOutlet UILabel *labelTemp;
@property (weak, nonatomic) IBOutlet UILabel *labelTime;
@property (weak, nonatomic) IBOutlet UILabel *labelWind;
@property (weak, nonatomic) IBOutlet UILabel *labelRain;
@property (weak, nonatomic) IBOutlet UILabel *labelLocation;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end
