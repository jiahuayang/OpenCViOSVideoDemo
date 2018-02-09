# OpenCViOSVideoDemo

## 环境
- Xcode8.1
- SDK10.1
- 真机测试 iPhoneSE 10.1.1

## [reference](http://www.swarthmore.edu/NatSci/mzucker1/opencv-2.4.10-docs/doc/tutorials/ios/video_processing/video_processing.html#opencviosvideoprocessing)


## 部分代码说明
```
self.videoCamera = [[CvVideoCamera alloc] initWithParentView:imageView];
self.videoCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionFront;
self.videoCamera.defaultAVCaptureSessionPreset = AVCaptureSessionPreset352x288;
self.videoCamera.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationPortrait;
self.videoCamera.defaultFPS = 30;
self.videoCamera.grayscale = NO;
```
这里初始化相机并且把imageView作为渲染每帧的显示。CvVideoCamera是基于'AVFoundion'包装的，所以我们能提供AVFoundation摄像头选择属性。例如我们想要使用前置摄像头，设置视频大小为352x288和视频方向(摄像头通常是横向输出，当你做一个竖向的应用时会导致数据错位)

设置defaultFPS设置为摄像机的FPS， 如果处理少于预期的FPS，帧被自动丢弃。

属性grayscale=YES使用不同的颜色空间，即 “YUV (YpCbCr 4:2:0)”，而grayscale=NO将输出32位BGRA。

此外，我们必须手动添加Opencv库的依赖库。项目工程中的框架有：

- CoreMedia.framework
- AVFoundation.framework
- opencv2.framework

## Processing frames
我们遵循代理模式，这在iOS中十分普遍，提供访问每个摄像帧的权限。基本上， 视图控制器必须实现CvVideoCameraDelegate协议并且设置为视频摄像头的代理：

```
@interface ViewController : UIViewController<CvVideoCameraDelegate>
```
```
- (void)viewDidLoad
{
    ...
    self.videoCamera = [[CvVideoCamera alloc] initWithParentView:imageView];
    self.videoCamera.delegate = self;
    ...
}
```
```
#pragma mark - Protocol CvVideoCameraDelegate

#ifdef __cplusplus
- (void)processImage:(Mat&)image;
{
    // Do some OpenCV stuff with the image
}
#endif
```
请注意我们在这里使用了C++(cv::Mat)。重要提醒：你必须能重命名视图控制器的后缀.m为.mm，以便能在Objective-C++ (Objective-C与 C++ 混编)下编译成功。 然后，当编译器处理C++代码文件时__cplusplus被定义。因此__cplusplus在哪里被定义我们代码就放在哪个代码块里。

## Hints
尽可能的避免昂贵的矩阵复制操作，尤其你的目标是实时处理。如果可能，尽可能的就地处理数据。
当你工作在灰度数据时，一次设置grayscale = YES作为YUV颜色空间来让你直接访问亮度平面。

Accelerate框架提供了一些CPU加速的DSP滤波器，这可以让你更得心应手。

