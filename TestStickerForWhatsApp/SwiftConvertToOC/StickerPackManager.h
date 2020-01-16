//
//  StickerPackManager.h
//  FancySticker
//
//  Created by wuyine on 2020/1/15.
//  Copyright © 2020 ckm. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
typedef void(^managerCompletionHandler)(NSMutableArray *array);
@interface StickerPackManager : NSObject
+ (instancetype)shareInstance;
- (NSDictionary *)stickersJSON:(NSString *)fileName;
- (void)fetchStickerPacks:(NSDictionary *)dict completionHandler:(managerCompletionHandler)completionHandler;
+ (dispatch_queue_t)queue;
@end

NS_ASSUME_NONNULL_END
