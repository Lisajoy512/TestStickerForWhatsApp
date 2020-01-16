//
//  ImageData.h
//  FancySticker
//
//  Created by wuyine on 2020/1/14.
//  Copyright © 2020 ckm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface ImageData : NSObject
@property (nonatomic,strong) NSData *data;
@property (nonatomic,copy) NSString *type;
@property (nonatomic,assign) int64_t bytesSize;
@property (nonatomic,assign) BOOL animated;
@property (nonatomic,strong) NSData *webpData;
@property (nonatomic,strong) UIImage *image;
+ (ImageData *)imageDataIfCompliant:(NSString *)fileName isTray:(BOOL)isTray;
+ (ImageData *)imageDataIfCompliant:(NSData *)rawData extensionType:(NSString *)extensionType isTray:(BOOL)isTray;
@end

NS_ASSUME_NONNULL_END
