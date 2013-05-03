//
//  ViewController.m
//  VFLDemo1
//
//  Created by Kevin on 4/27/13.
//  Copyright (c) 2013 Kevin. All rights reserved.
//

#import "ViewController.h"
#import "UIView+Autolayout.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    //[self example1];
    //[self example2];
    [self example3];
}

- (void)example1
{
    // Create our three labels using the category method
    UILabel *one = [UILabel autolayoutView];
    UILabel *two = [UILabel autolayoutView];
    UILabel *three = [UILabel autolayoutView];
    
    // Put some content in there for illustrations
    NSInteger labelNumber = 0;
    for (UILabel *label in @[one, two, three]) {
        label.backgroundColor = [UIColor redColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = [NSString stringWithFormat:@"%d", labelNumber++];
        [self.view addSubview:label];
    }
    
    // Create the views and metrics dictionaries
    NSDictionary *metrics = @{@"buttonWidth": @100.0};
    NSDictionary *views = NSDictionaryOfVariableBindings(one, two, three);
    
    // Horizontal layout - note the options for aligning the top and bottom of all views
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[one(two)]-[two(three)]-[three]-|" options:NSLayoutFormatAlignAllTop | NSLayoutFormatAlignAllBottom metrics:metrics views:views]];
    
    // Vertical layout - we only need one "column" of information because of the alignment options used when creating the horizontal layout
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[one(buttonWidth)]" options:0 metrics:metrics views:views]];
}

- (void)example2
{
    UIView *headerView = [UIView autolayoutView];
    headerView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:headerView];
    
    UILabel *headline = [UILabel autolayoutView];
    headline.font = [UIFont systemFontOfSize:30.0];
    headline.numberOfLines = 0;
    headline.preferredMaxLayoutWidth = 125.0; // This is necessary to allow the label to use multi-line text properly
    headline.backgroundColor = [UIColor yellowColor]; // So we can see the sizing
    headline.text = @"Kitten kills again";
    [headerView addSubview:headline];
    
    UILabel *byline = [UILabel autolayoutView];
    byline.font = [UIFont systemFontOfSize:14.0];
    byline.backgroundColor = [UIColor greenColor]; // So we can see the sizing
    byline.text = @"Paws McGruff";
    [headerView addSubview:byline];
    
    UIImageView *imageView = [UIImageView autolayoutView];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [headerView addSubview:imageView];
    
    // Lovely image loaded for example purposes
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *kitten = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://placekitten.com/150/150"] options:0 error:nil]];
        dispatch_async(dispatch_get_main_queue(), ^{
            imageView.image = kitten;
        });
    });
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    [button setTitle:@"Button" forState:UIControlStateNormal];
    [headerView addSubview:button];
    
    // Layout
    
    NSDictionary *views = NSDictionaryOfVariableBindings(headerView,headline,byline,imageView,button);
    NSDictionary *metrics = @{@"imageEdge":@150.0,@"padding":@15.0};
    
    // Header view fills the width of its superview
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[headerView]|" options:0 metrics:metrics views:views]];
    // Header view is pinned to the top of the superview
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[headerView]" options:0 metrics:metrics views:views]];
    
    // Headline and image horizontal layout
    [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-padding-[headline]-padding-[imageView(imageEdge)]-padding-|" options:0 metrics:metrics views:views]];
    
    // Headline and byline vertical layout - spacing at least zero between the two
    [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-padding-[headline]->=0-[byline]-padding-|" options:NSLayoutFormatAlignAllLeft metrics:metrics views:views]];
    
    // Image and button vertical layout - spacing at least zero between the two
    [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-padding-[imageView(imageEdge)]->=padding-[button]-padding-|" options:NSLayoutFormatAlignAllLeft | NSLayoutFormatAlignAllRight metrics:metrics views:views]];
}

- (void)example3
{
    UILabel *label = [UILabel autolayoutView];
    label.backgroundColor = [UIColor redColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"Hello World!";
    [self.view addSubview:label];
    
    NSDictionary *metrics = @{@"lowPriority":@(UILayoutPriorityDefaultLow)};
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-30.0@lowPriority-[label]" options:0 metrics:metrics views:NSDictionaryOfVariableBindings(label)]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
