//
//  LMScreenRecorder.h
//  LMGifGenerator
//
//  Created by Kun Wang on 15/9/2.
//  Copyright (c) 2015年 luckymore. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LMScreenRecorder : NSObject
//开始录制屏幕
- (void)startRecordingAtView:(UIView *)view targetDirectoryName:(NSString *)name;
- (void)stopRecording;
- (BOOL)isRecording;
@end
