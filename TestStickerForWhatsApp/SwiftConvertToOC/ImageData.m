//
//  ImageData.m
//  FancySticker
//
//  Created by wuyine on 2020/1/14.
//  Copyright © 2020 ckm. All rights reserved.
//

#import "ImageData.h"
#import "WebPManager.h"
#import "Limits.h"
@implementation ImageData

- (instancetype)initWithData:(NSData *)data WithType:(NSString *)type {
    if (self = [super init]) {
        self.data = data;
        self.type = type;
    }
    return self;
}

- (int64_t)bytesSize {
    return (int64_t)(self.data.length);
}

- (BOOL)animated {
    if ([self.type isEqualToString:@"webp"]) {
        return [[WebPManager shareInstance] isAnimated:self.data];
    }else {
        return NO;
    }
}

- (NSData *)webpData {
    if ([self.type isEqualToString:@"webp"]) {
        return self.data;
    }else {
        return [[WebPManager shareInstance] encode:self.data];
    }
}

- (UIImage *)image {
    if ([self.type isEqualToString:@"webp"]) {
        return [[WebPManager shareInstance] decode:self.data];
    }else {
        return [UIImage imageWithData:self.data];
    }
}

- (UIImage *)imageWithSize:(CGSize)size {
    if (!self.image) {
        return nil;
    }
    UIGraphicsBeginImageContextWithOptions(size, false, [UIScreen mainScreen].scale);
    [self.image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resizedImage;
}

+ (ImageData *)imageDataIfCompliant:(NSString *)fileName isTray:(BOOL)isTray {
    NSString *fileExtension = fileName.pathExtension;
    if (!([fileExtension isEqualToString:@"png"] || [fileExtension isEqualToString:@"webp"])) {
        NSLog(@"StickerPackError.unsupportedImageFormat");
        return nil;
    }
    NSURL *imageURL = [[NSBundle mainBundle] URLForResource:fileName withExtension:@""];
    if (!imageURL) {
        NSLog(@"StickerPackError.fileNotFound");
        return nil;
    }
    NSData *data = [NSData dataWithContentsOfURL:imageURL];
    return [ImageData imageDataIfCompliant:data extensionType:fileExtension isTray:isTray];
}

+ (ImageData *)imageDataIfCompliant:(NSData *)rawData extensionType:(NSString *)extensionType isTray:(BOOL)isTray {
    ImageData *imageData = [[ImageData alloc] initWithData:rawData WithType:extensionType];
    if (imageData.animated) {
        NSLog(@"StickerPackError.animatedImagesNotSupported");
        return nil;
    }
    if (isTray) {
        if (imageData.bytesSize > MaxTrayImageFileSize) {
            NSLog(@"StickerPackError.imageTooBig");
            return nil;
        }
        if (!CGSizeEqualToSize(imageData.image.size, TrayImageDimensions)) {
            NSLog(@"StickerPackError.incorrectImageSize");
            return nil;
        }
    }else {
        if (imageData.bytesSize > MaxStickerFileSize) {
            NSLog(@"StickerPackError.imageTooBig");
            return nil;
        }
        if (!CGSizeEqualToSize(imageData.image.size, ImageDimensions)) {
            NSLog(@"StickerPackError.incorrectImageSize");
            return nil;
        }
    }
    return imageData;
}

@end
