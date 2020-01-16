//
//  WebPManager.m
//  FancySticker
//
//  Created by wuyine on 2020/1/14.
//  Copyright © 2020 ckm. All rights reserved.
//

#import "WebPManager.h"
@implementation WebPManager
+ (instancetype)shareInstance {
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (BOOL)isAnimated:(NSData *)data {
    YYImageDecoder *decoder = [YYImageDecoder decoderWithData:data scale:1.0];
    if (decoder) {
        return decoder.frameCount > 1;
    }else {
        return NO;
    }
}

- (UIImage *)decode:(NSData *)data {
    YYImageDecoder *decoder = [YYImageDecoder decoderWithData:data scale:1.0];
    if (decoder) {
        return [decoder frameAtIndex:0 decodeForDisplay:YES].image;
    }else {
        return nil;
    }
}

- (NSData *)encode:(NSData *)data {
    YYImageEncoder *encoder = [[YYImageEncoder alloc] initWithType:YYImageTypeWebP];
    if (encoder) {
        [encoder addImageWithData:data duration:0];
        return encoder.encode;
    }else {
        return nil;
    }
}
@end
