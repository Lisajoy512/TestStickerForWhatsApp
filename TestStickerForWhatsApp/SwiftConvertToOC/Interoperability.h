//
//  Interoperability.h
//  FancySticker
//
//  Created by wuyine on 2020/1/14.
//  Copyright © 2020 ckm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface Interoperability : NSObject
+ (BOOL)canSend ;
+ (BOOL)send:(NSDictionary *)json;
+ (void)copyImageToPasteboard:(UIImage *)image;
@end

NS_ASSUME_NONNULL_END
