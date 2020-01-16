//
//  StickerPackManager.m
//  FancySticker
//
//  Created by wuyine on 2020/1/15.
//  Copyright © 2020 ckm. All rights reserved.
//

#import "StickerPackManager.h"
#import "Interoperability.h"
#import "StickerPack.h"
#import "Limits.h"
@implementation StickerPackManager
static dispatch_queue_t _queue;
+ (instancetype)shareInstance {
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
        
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        _queue = dispatch_queue_create("stickerPackQueue", DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}

- (NSDictionary *)stickersJSON:(NSString *)fileName {
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"wasticker"];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:path] options:NSDataReadingMappedAlways error:nil];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data
                                                        options:NSJSONReadingMutableContainers
                                                          error:nil];
    if (dic) {
        return dic;
    }else {
        NSLog(@"StickerPackError.fileNotFound");
        return nil;
    }
}

+ (dispatch_queue_t)queue {
    return _queue;
}

- (void)fetchStickerPacks:(NSDictionary *)dict completionHandler:(managerCompletionHandler)completionHandler {
    dispatch_async(_queue, ^{
        NSArray<NSDictionary *> *packs = dict[@"sticker_packs"];
        NSMutableArray *stickerPacks = [NSMutableArray new];
        NSMutableDictionary *currentIdentifiers = [NSMutableDictionary new];
        NSString *iosAppStoreLink = dict[@"ios_app_store_link"];
        NSString *androidAppStoreLink = dict[@"android_play_store_link"];
        
        for (NSDictionary *pack in packs) {
            NSString *packName = pack[@"name"];
            NSString *packPublisher = pack[@"publisher"];
            NSString *packTrayImageFileName = pack[@"tray_image_file"];
            NSString *packPublisherWebsite = pack[@"publisher_website"] ? @"" : nil;
            NSString *packPrivacyPolicyWebsite = pack[@"privacy_policy_website"] ? @"" : nil;
            NSString *packLicenseAgreementWebsite = pack[@"license_agreement_website"] ? @"" : nil;
            NSString *packIdentifier = pack[@"identifier"];
            
            if (packIdentifier != nil && currentIdentifiers[packIdentifier] == nil) {
                currentIdentifiers[packIdentifier] = @(YES);
            }else {
                NSLog(@"Missing identifier or a sticker pack already has the identifier");
                return ;
            }
            
            StickerPack *stickerPack = [[StickerPack alloc] initWithIndentifier:packIdentifier
                                                                           name:packName
                                                                      publisher:packPublisher
                                                               trayImageFileName:packTrayImageFileName
                                                               publisherWebsite:packPublisherWebsite
                                                           privacyPolicyWebsite:packPrivacyPolicyWebsite
                                                        licenseAgreementWebsite:packLicenseAgreementWebsite];
            NSMutableArray *stickers = pack[@"stickers"];
            for (NSDictionary *sticker in stickers) {
                NSString *filename = sticker[@"image_file"];
                [stickerPack addSticker:filename];
            }
            
            if (stickers.count < MinStickersPerPack) {
                NSLog(@"Sticker count smaller that the allowable limit");
                return ;
            }
            [stickerPacks addObject:stickerPack];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            completionHandler(stickerPacks);
        });
    });
}
@end
