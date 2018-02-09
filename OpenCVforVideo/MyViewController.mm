//
//  MyViewController.m
//  OpenCVforVideo
//
//  ref: http://www.swarthmore.edu/NatSci/mzucker1/opencv-2.4.10-docs/doc/tutorials/ios/video_processing/video_processing.html#opencviosvideoprocessing
//
//  Created by yangjiahua on 2018/2/8.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "MyViewController.h"
#import <opencv2/highgui/cap_ios.h>

using namespace cv;

@interface MyViewController ()<CvVideoCameraDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (strong, nonatomic) IBOutlet UIView *startButton;

@property (strong, retain) CvVideoCamera* videoCamera;

@end

@implementation MyViewController


- (IBAction)startButton:(id)sender {
    XLog(@"hahah");
    [self.videoCamera start];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.videoCamera = [[CvVideoCamera alloc] initWithParentView:_imageView];
    self.videoCamera.delegate = self;
    self.videoCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionFront;
    self.videoCamera.defaultAVCaptureSessionPreset = AVCaptureSessionPreset1280x720;
    self.videoCamera.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationPortrait;
    self.videoCamera.defaultFPS = 30;
    self.videoCamera.grayscaleMode = NO;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Protocol CvVideoCameraDelegate

#ifdef __cplusplus
- (void)processImage:(Mat&)image;{
    
    
    Mat image_copy;
    cvtColor(image, image_copy, CV_BGRA2BGR);
    
    // invert image
    bitwise_not(image_copy, image_copy);
    cvtColor(image_copy, image, CV_BGR2BGRA);
    
}
#endif

@end
