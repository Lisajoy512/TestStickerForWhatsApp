//
//  StickerPack.h
//  FancySticker
//
//  Created by wuyine on 2020/1/14.
//  Copyright © 2020 ckm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageData.h"
NS_ASSUME_NONNULL_BEGIN
typedef enum : NSInteger {
    fileNotFound,
    emptyString,
    unsupportedImageFormat,
    imageTooBig,
    incorrectImageSize,
    animatedImagesNotSupported,
    stickersNumOutsideAllowableRange,
    stringTooLong,
    tooManyEmojis
} StickerPackError;

typedef void(^completionHandler)(BOOL);

@interface StickerPack : NSObject
@property (nonatomic,copy) NSString *identifier;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *publisher;
@property (nonatomic,strong) ImageData *trayImage;
@property (nonatomic,copy) NSString *publisherWebsite;
@property (nonatomic,copy) NSString *privacyPolicyWebsite;
@property (nonatomic,copy) NSString *licenseAgreementWebsite;
@property (nonatomic,strong) NSMutableArray *stickers;
@property (nonatomic,assign) int64_t bytesSize;
@property (nonatomic,copy) NSString *formattedSize;

- (instancetype)initWithIndentifier:(NSString *)identifier
                               name:(NSString *)name
                          publisher:(NSString *)publisher
                  trayImageFileName:(NSString *)trayImageFileName
                   publisherWebsite:(NSString *)publisherWebsite
               privacyPolicyWebsite:(NSString *)privacyPolicyWebsite
            licenseAgreementWebsite:(NSString *)licenseAgreementWebsite;

- (instancetype)initWithIndentifier:(NSString *)identifier
                   name:(NSString *)name
              publisher:(NSString *)publisher
      trayImagePNGData:(NSData *)trayImagePNGData
       publisherWebsite:(NSString *)publisherWebsite
   privacyPolicyWebsite:(NSString *)privacyPolicyWebsite
            licenseAgreementWebsite:(NSString *)licenseAgreementWebsite;
- (void)addSticker:(NSString *)fileName;
- (void)addSticker:(NSData *)imageData type:(NSString *)type;
- (void)sendToWhatsApp:(completionHandler)completionHandler;
@end

NS_ASSUME_NONNULL_END
