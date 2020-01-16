//
//  Interoperability.m
//  FancySticker
//
//  Created by wuyine on 2020/1/14.
//  Copyright © 2020 ckm. All rights reserved.
//

#import "Interoperability.h"
static NSString *DefaultBundleIdentifier = @"WA.WAStickersThirdParty";
static NSInteger PasteboardExpirationSeconds = 60;
static NSString *PasteboardStickerPackDataType = @"net.whatsapp.third-party.sticker-pack";
static NSString *WhatsAppURLString = @"whatsapp://stickerPack";
static NSString *iOSAppStoreLink = @"";
static NSString *AndroidStoreLink = @"";
@interface Interoperability()
@end

@implementation Interoperability
+ (BOOL)canSend {
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"whatsapp://"]];
}

+ (BOOL)send:(NSDictionary *)json {
    NSString *bundleIdentifier = [NSBundle mainBundle].bundleIdentifier;
    if ([bundleIdentifier rangeOfString:DefaultBundleIdentifier].location != NSNotFound) {
        NSLog(@"Your bundle identifier must not include the default one.");
        return NO;
    }
    UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
    NSDictionary *jsonWithAppStoreLink = json;
//    [jsonWithAppStoreLink setValue:iOSAppStoreLink forKey:@"ios_app_store_link"];
//    [jsonWithAppStoreLink setValue:AndroidStoreLink forKey:@"android_play_store_link"];
    
    NSError *parseError = nil;
    NSData *dataToSend = [NSJSONSerialization dataWithJSONObject:jsonWithAppStoreLink options:NSJSONWritingPrettyPrinted error:&parseError];
    if (!dataToSend) {
        NSLog(@"dataWithJSONObject error");
        return NO;
    }
    
    if (@available(iOS 10.0, *)) {
        [pasteBoard setItems:@[@{PasteboardStickerPackDataType:dataToSend}]
                    options:@{UIPasteboardOptionLocalOnly:@(YES),
                              UIPasteboardOptionExpirationDate:[NSDate dateWithTimeIntervalSinceNow:PasteboardExpirationSeconds]}
        ];
    }else {
        [pasteBoard setData:dataToSend forPasteboardType:PasteboardStickerPackDataType];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self canSend]) {
            if (@available(iOS 10.0, *)) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:WhatsAppURLString] options:@{} completionHandler:^(BOOL success) {
                    if (success) {
                        NSLog(@"调起whats app成功");
                    }
                }];
            }
        }
    });
    return YES;
}

+ (void)copyImageToPasteboard:(UIImage *)image {
    [UIPasteboard generalPasteboard].image = image;
}
@end
