//
//  ViewController.m
//  CEMovieMaker
//
//  Created by Cameron Ehrlich on 9/17/14.
//  Copyright (c) 2014 Cameron Ehrlich. All rights reserved.
//

#import "ViewController.h"
#import "CEMovieMaker.h"

@import MediaPlayer;

@interface ViewController ()

@property(nonatomic, strong) CEMovieMaker *movieMaker;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"icon2"] forState:UIControlStateNormal];
    [button setFrame:CGRectMake(0, 0, self.view.bounds.size.width, 100)];
    [button.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [button addTarget:self action:@selector(process:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)process:(id)sender {
    NSMutableArray *frames = [[NSMutableArray alloc] init];

    UIImage *icon1 = [UIImage imageNamed:@"icon1"];
    UIImage *icon2 = [UIImage imageNamed:@"icon2"];
    UIImage *icon3 = [UIImage imageNamed:@"icon3"];

    NSDictionary *settings = [CEMovieMaker videoSettingsWithCodec:AVVideoCodecH264 withWidth:icon1.size.width andHeight:icon1.size.height];
    self.movieMaker = [[CEMovieMaker alloc] initWithSettings:settings];
    NSMutableArray *frameTimes = [NSMutableArray array];
    [frames addObject:icon1];
    [frames addObject:icon2];
    [frames addObject:icon3];

    CMTime frameTime = CMTimeMakeWithSeconds(0, NSEC_PER_SEC);
    NSValue *vFrameTime = [NSValue valueWithCMTime:frameTime];
    [frameTimes addObject:vFrameTime];
    frameTime = CMTimeMakeWithSeconds(0.35, NSEC_PER_SEC);
    vFrameTime = [NSValue valueWithCMTime:frameTime];
    [frameTimes addObject:vFrameTime];
    frameTime = CMTimeMakeWithSeconds(3, NSEC_PER_SEC);
    vFrameTime = [NSValue valueWithCMTime:frameTime];
    [frameTimes addObject:vFrameTime];

    [self.movieMaker setFrameTimes:frameTimes];

    [self.movieMaker createMovieFromImages:[frames copy] withCompletion:^(NSURL *fileURL) {
        [self viewMovieAtUrl:fileURL];
    }];
}

- (void)viewMovieAtUrl:(NSURL *)fileURL {
    MPMoviePlayerViewController *playerController = [[MPMoviePlayerViewController alloc] initWithContentURL:fileURL];
    [playerController.view setFrame:self.view.bounds];
    [self presentMoviePlayerViewControllerAnimated:playerController];
    [playerController.moviePlayer prepareToPlay];
    [playerController.moviePlayer play];
    [self.view addSubview:playerController.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
