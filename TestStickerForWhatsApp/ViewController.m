//
//  ViewController.m
//  TestStickerForWhatsApp
//
//  Created by wuyine on 2020/1/16.
//  Copyright © 2020 wuyine. All rights reserved.
//

#import "ViewController.h"
#import "StickerPackManager.h"
#import "StickerPack.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor greenColor];
    btn.frame = CGRectMake(100, 200, 200, 50);
    [btn setTitle:@"Add to WhatsApp" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(addTo) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btn];
}

- (void)addTo {
    [[StickerPackManager shareInstance] fetchStickerPacks:[[StickerPackManager shareInstance] stickersJSON:@"sticker_packs"] completionHandler:^(NSMutableArray * _Nonnull array) {
        for (StickerPack *pack in array) {
            [pack sendToWhatsApp:^(BOOL success) {
                if (success) {
                    NSLog(@"succ");
                }else {
                    NSLog(@"failure");
                }
            }];
        }
    }];
}

@end
