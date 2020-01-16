//
//  Sticker.h
//  FancySticker
//
//  Created by wuyine on 2020/1/15.
//  Copyright © 2020 ckm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageData.h"
NS_ASSUME_NONNULL_BEGIN

@interface Sticker : NSObject
@property (nonatomic,strong) ImageData *imageData;
@property (nonatomic,strong) NSArray *emojis;
@property (nonatomic,assign) int64_t bytesSize;
- (instancetype)initWithContentsOfFile:(NSString *)fileName;
- (instancetype)initWithImageData:(NSData *)imageData type:(NSString *)type;
- (void)copyToPasteboardAsImage;
@end

NS_ASSUME_NONNULL_END
