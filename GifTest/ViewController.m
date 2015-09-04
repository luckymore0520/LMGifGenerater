//
//  ViewController.m
//  GifTest
//
//  Created by Kun Wang on 15/9/2.
//  Copyright (c) 2015年 luckymore. All rights reserved.
//

#import "ViewController.h"
#import "LMGifGenerator.h"
#import "LMScreenRecorder.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *startRecordingButton;
@property (nonatomic, strong) LMGifGenerator *generator;
@property (nonatomic, strong) LMScreenRecorder *recorder;
@property (weak, nonatomic) IBOutlet UIView *recordingView;
@property (weak, nonatomic) IBOutlet UIImageView *replayImageView;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onReplayImageTaped)];
    [self.replayImageView addGestureRecognizer:tapGestureRecognizer];
}

- (LMGifGenerator *)generator {
    if (!_generator) {
        LMGifGenerator *generator = [[LMGifGenerator alloc] init];
        self.generator = generator;
    }
    return _generator;
}

- (LMScreenRecorder *)recorder {
    if (!_recorder) {
        _recorder = [[LMScreenRecorder alloc] init];
    }
    return _recorder;
}

#pragma mark - Selector
- (void)onReplayImageTaped {
    [self.replayImageView setImage:nil];
    [self.replayImageView setHidden:YES];
}

#pragma mark - ButtonAction
- (IBAction)startRecording:(id)sender {
    if (!self.recorder.isRecording) {
        [sender setSelected:YES];
        [self.recorder startRecordingAtView:self.recordingView targetDirectoryName:@"test1"];
    } else {
        [sender setSelected:NO];
        [self.recorder stopRecording];
    }
}

- (IBAction)replay:(id)sender {
    [self.generator generateGifWithName:@"test1"];
    [self.replayImageView setImage:[self.generator getGifImageOfName:@"test1"]];
    [self.replayImageView setHidden:NO];
}


- (IBAction)onChangeBackgroundButtonClicked:(id)sender {
    [self.recordingView setBackgroundColor:[self randomColor]];
}

#pragma mark - Private
- (UIColor*)randomColor {
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    return color;
    
}

@end
