//
//  LMScreenRecorder.m
//  LMGifGenerator
//
//  Created by Kun Wang on 15/9/2.
//  Copyright (c) 2015年 luckymore. All rights reserved.
//

#import "LMScreenRecorder.h"

@interface LMScreenRecorder()
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, weak) UIView *targetView;
@property (nonatomic, strong) NSString *targetFileName;
@end

@implementation LMScreenRecorder

#pragma mark - Public
- (BOOL)isRecording {
    return _targetFileName!=nil;
}

- (void)startRecordingAtView:(UIView *)view targetDirectoryName:(NSString *)name{
    self.targetView = view;
    self.targetFileName = name;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(recordScreen) userInfo:nil repeats:YES];
    [self.timer fire];
}

- (void)stopRecording {
    [self.timer invalidate];
    self.timer = nil;
    self.index = 0;
    self.targetView = nil;
    self.targetFileName = nil;
}

#pragma mark - Selector
- (void)recordScreen {
    UIImage *screen = [self imageWithView:self.targetView];;
    [self saveImageAtDirectoryName:self.targetFileName image:screen];
}

#pragma mark - Private
- (UIImage *)imageWithView:(UIView *)view {
    CGSize s = view.bounds.size;
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了
    UIGraphicsBeginImageContextWithOptions(s, NO, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void) saveImageAtDirectoryName:(NSString *)name image:(UIImage *)image {
    NSArray *document = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentStr = [document objectAtIndex:0];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *textDirectory = [documentStr stringByAppendingPathComponent:[NSString stringWithFormat:@"screen/%@",name]];
    [fileManager createDirectoryAtPath:textDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    NSData *imageData = UIImagePNGRepresentation(image);
    NSString *path = [NSString stringWithFormat:@"%ld.png",self.index];
    [imageData writeToFile:[textDirectory stringByAppendingPathComponent:path] atomically:YES];
    self.index++;
    NSLog(@"%ld",self.index);
}

@end
