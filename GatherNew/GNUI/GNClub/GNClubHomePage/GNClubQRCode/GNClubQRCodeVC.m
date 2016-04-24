//
//  GNClubQRCodeVC.m
//  GatherNew
//
//  Created by apple on 15/7/9.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNClubQRCodeVC.h"
#import "GNShareService.h"

@interface GNClubQRCodeVC ()

@property (nonatomic, strong) GNClubDetailModel *model;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation GNClubQRCodeVC

+ (NSString *)sbIdentifier {
    return @"club_qr_code";
}

- (void)setupUI {
    [super setupUI];
    
    self.imageView.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"share"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(shareButtonPressed:)];
}


- (instancetype)initWithClubModel:(GNClubDetailModel *)model {
    self = [[self class] loadFromGNUI:[GNUI clubUI]];
    if (self) {
        self.model = model;
    }
    return self;
}

- (void)binding {
    [self.imageView setImageWithURLString:self.model.qr_code_url];
}

- (void)shareButtonPressed:(UIBarButtonItem *)item {
    [GNShareService shareClub:self.model];
}

@end
