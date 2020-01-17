//
//  StickerPack.m
//  FancySticker
//
//  Created by wuyine on 2020/1/14.
//  Copyright © 2020 ckm. All rights reserved.
//

#import "StickerPack.h"
#import "Limits.h"
#import "ImageData.h"
#import "Sticker.h"
#import "StickerPackManager.h"
#import "Interoperability.h"
@implementation StickerPack

- (instancetype)initWithIndentifier:(NSString *)identifier
                               name:(NSString *)name
                          publisher:(NSString *)publisher
                  trayImageFileName:(NSString *)trayImageFileName
                   publisherWebsite:(NSString *)publisherWebsite
               privacyPolicyWebsite:(NSString *)privacyPolicyWebsite
            licenseAgreementWebsite:(NSString *)licenseAgreementWebsite {
    if (self = [super init]) {
        if (name.length == 0 || publisher.length == 0 || identifier.length == 0) {
            NSLog(@"StickerPackError.emptyString");
        }
        if (name.length > MaxCharLimit128 || publisher.length > MaxCharLimit128 || identifier.length > MaxCharLimit128 ) {
            NSLog(@"StickerPackError.stringTooLong");
        }
        self.identifier = identifier;
        self.name = name;
        self.publisher = publisher;
        self.publisherWebsite = publisherWebsite;
        self.privacyPolicyWebsite = privacyPolicyWebsite;
        self.licenseAgreementWebsite = licenseAgreementWebsite;
        
        ImageData *trayCompliantImageData = [ImageData imageDataIfCompliant:trayImageFileName isTray:YES];
        if (trayCompliantImageData) {
            self.trayImage = trayCompliantImageData;
        }
        self.stickers = [NSMutableArray new];
    }
    return self;
}

- (instancetype)initWithIndentifier:(NSString *)identifier
                   name:(NSString *)name
              publisher:(NSString *)publisher
      trayImagePNGData:(NSData *)trayImagePNGData
       publisherWebsite:(NSString *)publisherWebsite
   privacyPolicyWebsite:(NSString *)privacyPolicyWebsite
licenseAgreementWebsite:(NSString *)licenseAgreementWebsite {
    if (self = [super init]) {
        if (name.length && publisher.length && identifier.length) {
            NSLog(@"StickerPackError.emptyString");
        }
        if (name.length > MaxCharLimit128 || publisher.length > MaxCharLimit128 || identifier.length > MaxCharLimit128 ) {
            NSLog(@"StickerPackError.stringTooLong");
        }
        self.identifier = identifier;
        self.name = name;
        self.publisher = publisher;
        self.publisherWebsite = publisherWebsite;
        self.privacyPolicyWebsite = privacyPolicyWebsite;
        self.licenseAgreementWebsite = licenseAgreementWebsite;
        
        ImageData *trayCompliantImageData = [ImageData imageDataIfCompliant:trayImagePNGData extensionType:@"png" isTray:YES];
        if (trayCompliantImageData) {
            self.trayImage = trayCompliantImageData;
        }
        self.stickers = [NSMutableArray new];
    }
    return self;
}

- (void)addSticker:(NSString *)fileName {
    if (self.stickers.count > MaxStickersPerPack) {
        NSLog(@"StickerPackError.stickersNumOutsideAllowableRange");
        return;
    }
    Sticker *sticker = [[Sticker alloc] initWithContentsOfFile:fileName];
    [self.stickers addObject:sticker];
}

- (void)addSticker:(NSData *)imageData type:(NSString *)type {
    if (self.stickers.count > MaxStickersPerPack) {
        NSLog(@"StickerPackError.stickersNumOutsideAllowableRange");
        return;
    }
    Sticker *sticker = [[Sticker alloc] initWithImageData:imageData type:type];
    [self.stickers addObject:sticker];
}

- (void)sendToWhatsApp:(completionHandler)completionHandler {
    dispatch_async([StickerPackManager queue], ^{
        NSMutableDictionary *json = [NSMutableDictionary new];
        json[@"identifier"] = self.identifier;
        json[@"name"] = self.name;
        json[@"publisher"] = self.publisher;
        json[@"tray_image"] = [UIImagePNGRepresentation(self.trayImage.image) base64EncodedStringWithOptions:0];
        NSMutableArray *stickersArray = [NSMutableArray new];
        for (Sticker *sticker in self.stickers) {
            NSMutableDictionary *stickerDict = [NSMutableDictionary new];
            NSData *imageData = sticker.imageData.webpData;
            if (imageData) {
                stickerDict[@"image_data"] = [imageData base64EncodedStringWithOptions:0];
            }else {
                NSLog(@"skip bad data");
                continue;
            }
            stickerDict[@"emojis"] = sticker.emojis;
            [stickersArray addObject:stickerDict];
        }
        json[@"stickers"] = stickersArray;
        BOOL result = [Interoperability send:json];
        dispatch_async(dispatch_get_main_queue(), ^{
            completionHandler(result);
        });
    });
}

#pragma mark -- getter
- (int64_t)bytesSize {
    int64_t totalBytes = (int64_t)([self.name stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLPathAllowedCharacterSet]].length + [self.publisher stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLPathAllowedCharacterSet]].length);
    return totalBytes;
}

- (NSString *)formattedSize {
    return [NSByteCountFormatter stringFromByteCount:self.bytesSize countStyle:NSByteCountFormatterCountStyleFile];
}
@end
