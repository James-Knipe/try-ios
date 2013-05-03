//
//  ViewController.h
//  ImageDownload
//
//  Created by Kevin on 4/28/13.
//  Copyright (c) 2013 Kevin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<NSURLConnectionDataDelegate, NSURLConnectionDataDelegate>

@property(nonatomic, strong) NSMutableData *imageData;
@property(nonatomic, assign) float length;
@property(nonatomic, strong) IBOutlet UIProgressView *progressView;
@property(nonatomic, strong) IBOutlet UIImageView *imageView;
@property(nonatomic, strong) IBOutlet UILabel *timeLabel;

- (IBAction)startDownload;
- (IBAction)cancelDownload;
- (void)saveLocally:(NSData *)imgData;

@end
