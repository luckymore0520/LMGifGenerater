//
//  GifGenerator.m
//  GifTest
//
//  Created by Kun Wang on 15/9/2.
//  Copyright (c) 2015年 luckymore. All rights reserved.
//

#import "LMGifGenerator.h"
#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "UIImage+GIF.h"


@implementation LMGifGenerator
#pragma mark - Public
- (void)generateGifWithImageArray:(NSArray *)imgs targetFileName:(NSString *)targetFileName{
    //图像目标
    CGImageDestinationRef destination;
    //创建输出路径
    NSArray *document = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentStr = [document objectAtIndex:0];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *textDirectory = [documentStr stringByAppendingPathComponent:@"gif"];
    [fileManager createDirectoryAtPath:textDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *path = [textDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.gif",targetFileName]];
    NSLog(@"%@",path);
    //创建CFURL对象
    /*
     CFURLCreateWithFileSystemPath(CFAllocatorRef allocator, CFStringRef filePath, CFURLPathStyle pathStyle, Boolean isDirectory)
     
     allocator : 分配器,通常使用kCFAllocatorDefault
     filePath : 路径
     pathStyle : 路径风格,我们就填写kCFURLPOSIXPathStyle 更多请打问号自己进去帮助看
     isDirectory : 一个布尔值,用于指定是否filePath被当作一个目录路径解决时相对路径组件
     */
    CFURLRef url = CFURLCreateWithFileSystemPath (
                                                  kCFAllocatorDefault,
                                                  (CFStringRef)path,
                                                  kCFURLPOSIXPathStyle,
                                                  false);
    
    //通过一个url返回图像目标
    destination = CGImageDestinationCreateWithURL(url, kUTTypeGIF, imgs.count, NULL);
    
    //设置gif的信息,播放间隔时间,基本数据,和delay时间
    NSDictionary *frameProperties = [NSDictionary
                                     dictionaryWithObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:0.05], (NSString *)kCGImagePropertyGIFDelayTime, nil]
                                     forKey:(NSString *)kCGImagePropertyGIFDictionary];
    
    //设置gif信息
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:4];
    [dict setObject:[NSNumber numberWithBool:YES] forKey:(NSString*)kCGImagePropertyGIFHasGlobalColorMap];
    [dict setObject:(NSString *)kCGImagePropertyColorModelRGB forKey:(NSString *)kCGImagePropertyColorModel];
    [dict setObject:[NSNumber numberWithInt:8] forKey:(NSString*)kCGImagePropertyDepth];
    [dict setObject:[NSNumber numberWithInt:0] forKey:(NSString *)kCGImagePropertyGIFLoopCount];
    NSDictionary *gifProperties = [NSDictionary dictionaryWithObject:dict
                                                              forKey:(NSString *)kCGImagePropertyGIFDictionary];
    //合成gif
    for (UIImage* dImg in imgs)
    {
        CGImageDestinationAddImage(destination, dImg.CGImage, (__bridge CFDictionaryRef)frameProperties);
    }
    CGImageDestinationSetProperties(destination, (__bridge CFDictionaryRef)gifProperties);
    CGImageDestinationFinalize(destination);
    CFRelease(destination);
}

- (void)generateGifWithName:(NSString *)name {
    //gif的制作
    //获取源数据image
    NSArray *imgs = [self getImageArrayWithDirectoryName:name];
    [self generateGifWithImageArray:imgs targetFileName:name];
}

- (UIImage *)getGifImageOfName:(NSString *)name{
    //创建输出路径
    NSArray *document = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentStr = [document objectAtIndex:0];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *textDirectory = [documentStr stringByAppendingPathComponent:@"gif"];
    [fileManager createDirectoryAtPath:textDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *path = [textDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.gif",name]];
    NSData *data = [NSData dataWithContentsOfFile:path];
    UIImage *image = [UIImage sd_animatedGIFWithData:data];
    return image;
}

#pragma mark - Private
- (NSArray *)getImageArrayWithDirectoryName:(NSString *)name {
    NSArray *document = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentStr = [document objectAtIndex:0];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *textDirectory = [documentStr stringByAppendingPathComponent:[NSString stringWithFormat:@"screen/%@",name]];
    [fileManager createDirectoryAtPath:textDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    NSData *imageData;
    NSInteger index = 0;
    NSMutableArray *imageArray = [[NSMutableArray alloc] init];
    while ((imageData = [NSData dataWithContentsOfFile:[textDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%ld.png",index]]])) {
        [imageArray addObject:[UIImage imageWithData:imageData]];
        index ++;
    }
    return imageArray;
}
@end
