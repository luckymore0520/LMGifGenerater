//
//  GifGenerator.h
//  GifTest
//
//  Created by Kun Wang on 15/9/2.
//  Copyright (c) 2015年 luckymore. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface LMGifGenerator : NSObject
//获取对应路径中的图片，并将其合成GIF，路径在screen/name中
- (void)generateGifWithName:(NSString *)name;
//传入图片，将其合成GIF，定义目标GIF图片名称
- (void)generateGifWithImageArray:(NSArray *)imgs targetFileName:(NSString *)targetFileName;
//根据名称获取GIF图片
- (UIImage *)getGifImageOfName:(NSString *)name;
@end
