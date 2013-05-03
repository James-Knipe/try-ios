//
//  ViewController.h
//  VideoApp
//
//  Created by Kevin on 5/1/13.
//  Copyright (c) 2013 Kevin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface ViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property(copy, nonatomic) NSURL *movieURL;
@property(strong, nonatomic) MPMoviePlayerController *movieController;

- (IBAction)takeVideo:(UIButton *)sender;

@end
