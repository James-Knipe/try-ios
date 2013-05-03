//
//  ViewController.m
//  ImageDownload
//
//  Created by Kevin on 4/28/13.
//  Copyright (c) 2013 Kevin. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property(nonatomic, strong) NSURLConnection *connection;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (IBAction)startDownload
{
    [self.progressView setProgress:0 animated:YES];
    self.imageData = [[NSMutableData alloc]init];
    self.connection = [NSURLConnection connectionWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.raincoast.org/wp-content/uploads/S1I1596grizzlysittingattideline547-10MB.jpg"]] delegate:self];
}

- (IBAction)cancelDownload
{
    self.imageData = [[NSMutableData alloc]init];
    [self.connection cancel];
    self.connection = nil;
}

- (void)saveLocally:(NSData *)imgData
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSDate *aDate = [NSDate date];
    NSTimeInterval interval = [aDate timeIntervalSince1970];
    NSString *localFilePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.jpeg",(int)interval]];
    [imgData writeToFile:localFilePath atomically:YES];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.length = [response expectedContentLength];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.imageData appendData:data];
    float progress = (float)[self.imageData length]/(float)self.length;
    self.timeLabel.text = [NSString stringWithFormat:@"%0.2f%%", progress * 100];
    [self.progressView setProgress:progress animated:YES];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"didFailGetImageData");
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    UIImage *image = [UIImage imageWithData:self.imageData];
    self.imageView.image = image;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
