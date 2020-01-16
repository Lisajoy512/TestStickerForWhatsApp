//
//  WebPManager.h
//  FancySticker
//
//  Created by wuyine on 2020/1/14.
//  Copyright © 2020 ckm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYImage.h"

NS_ASSUME_NONNULL_BEGIN

@interface WebPManager : NSObject
+ (instancetype)shareInstance;
- (BOOL)isAnimated:(NSData *)data;
- (UIImage *)decode:(NSData *)data;
- (NSData *)encode:(NSData *)data;
@end

NS_ASSUME_NONNULL_END
