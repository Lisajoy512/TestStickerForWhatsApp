//
//  Sticker.m
//  FancySticker
//
//  Created by wuyine on 2020/1/15.
//  Copyright © 2020 ckm. All rights reserved.
//

#import "Sticker.h"
#import "Interoperability.h"
@implementation Sticker
- (instancetype)initWithContentsOfFile:(NSString *)fileName {
    if (self = [super init]) {
        self.imageData = [ImageData imageDataIfCompliant:fileName isTray:NO];
        self.emojis = @[];
    }
    return self;
}

- (instancetype)initWithImageData:(NSData *)imageData type:(NSString *)type {
    if (self = [super init]) {
        self.imageData = [ImageData imageDataIfCompliant:imageData extensionType:type isTray:NO];
    }
    return self;
}

- (void)copyToPasteboardAsImage {
    UIImage *image = self.imageData.image;
    if (image) {
        [Interoperability copyImageToPasteboard:image];
    }
}

- (NSArray *)emojis {
    if (!_emojis) {
        _emojis = @[];
    }
    return _emojis;
}
@end
