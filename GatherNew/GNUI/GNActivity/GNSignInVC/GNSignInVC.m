//
//  GNSignInVC.m
//  GatherNew
//
//  Created by apple on 15/7/31.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import <Masonry.h>
#import "GNSignInVC.h"
#import "GNSignInCVC.h"
#import "GNSignInSlider.h"
#import "GNMenuOptionVC.h"
#import "GNActivitySignInVM.h"
#import "GNActivityAlbumContainerVC.h"
#import "GNMemberVC.h"

@interface GNSignInVC ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *layout;
@property (weak, nonatomic) IBOutlet UIView *signInSliderContainView;
@property (weak, nonatomic) IBOutlet UILabel *hintLabel;
@property (weak, nonatomic) IBOutlet UIImageView *hintImageView;
@property (weak, nonatomic) IBOutlet UIView *hintContainView;
@property (weak, nonatomic) IBOutlet UIView *memberAlbumContainView;

@property (nonatomic, strong) GNSignInSlider *slider;
@property (nonatomic, strong) GNMenuOptionVC *menu;

@property (nonatomic, strong) GNActivitySignInVM *viewModel;

@end

@implementation GNSignInVC

+ (NSString *)sbIdentifier {
    return @"sign_in";
}

- (void)setupUI {
    [super setupUI];
    [self setTitle:@"签到"];
    
    CGFloat distance = (kUIScreenWidth-140)/2;
    
    self.collectionView.pagingEnabled = YES;
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.layout.minimumInteritemSpacing = 0;
    self.layout.minimumLineSpacing = distance*2;
    self.layout.sectionInset = UIEdgeInsetsMake(0, distance, 0,distance);
    self.hintContainView.hidden = YES;
    self.memberAlbumContainView.hidden = YES;
    
    self.menu = [[GNMenuOptionVC alloc] initWithOptions:@[@"成员", @"相册"]];
    [self.view addSubview:self.menu.view];
    [self.menu autoShowOrHide];
    /*self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"sign_in_more"]
                                                                                     imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:nil
                                                                             action:Nil];
    __weakify;
    /self.navigationItem.rightBarButtonItem.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        __strongify;
        
        [self.menu autoShowOrHide];
        
        return [RACSignal empty];
    }];*/
    
    self.slider = [[GNSignInSlider alloc] init];
    self.signInSliderContainView.backgroundColor = [UIColor clearColor];
    [self.signInSliderContainView addSubview:self.slider];
    [self.hintLabel setTextColor:kUIColorWithHexUint(GNUIColorDarkgray)];
    [self setHintViewHidden:YES];
}

- (IBAction)memberButtonPressed:(id)sender {
    if (self.viewModel.activityId > 0) {
        GNMemberVC *controller = [[GNMemberVC alloc] initWithType:GNMemberTypeActivity typeId:self.viewModel.activityId];
        [self.navigationController pushVC:controller animated:YES];
    }
}

- (IBAction)albumButtonPressed:(id)sender {
    if (self.viewModel.activityId > 0) {
        GNActivityAlbumContainerVC *controller = [[GNActivityAlbumContainerVC alloc] initWithActivityId:self.viewModel.activityId canUpload:YES];
        [self.navigationController pushVC:controller animated:YES];
    }
}

- (instancetype)initWithSignInIdentifier:(NSString *)identifier {
    self = [self.class loadFromStoryboard];
    if (self) {
        self.viewModel = [[GNActivitySignInVM alloc] initWithSignInIdentifier:identifier];
    }
    return self;
}

- (void)setHintViewHidden:(BOOL)hidden {
    self.hintLabel.hidden = hidden;
    self.hintImageView.hidden = hidden;
}

- (void)binding {
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    __weakify;
    [self.menu didSelectOption:^(NSUInteger index) {
        
        if (self.viewModel.activityId > 0) {
            if (index == 0) {
                GNMemberVC *controller = [[GNMemberVC alloc] initWithType:GNMemberTypeActivity typeId:self.viewModel.activityId];
                [self.navigationController pushVC:controller animated:YES];
            }else if (index == 1) {
                GNActivityAlbumContainerVC *controller = [[GNActivityAlbumContainerVC alloc] initWithActivityId:self.viewModel.signInInfo.activity_id canUpload:YES];
                [self.navigationController pushVC:controller animated:YES];
            }
        }
    }];
    
    [self.slider endNoticeBlock:^{
        __strongify;
        [self.viewModel.signInResponse start];
    }];
    
    [self.viewModel.signInInfoResponse start:YES success:^(id response, GNActivitySignInModel *model) {
        __strongify;
        
        [self.slider setHidden:NO];
        [self.memberAlbumContainView setHidden:NO];
        [self.collectionView reloadData];
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:(model.step-1) inSection:0]
                                    atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    } error:^(id response, NSInteger code) {
        __strongify;
        [[[UIAlertView alloc] initWithTitle:nil
                                    message:[response objectForKey:@"message"]
                                   delegate:nil
                          cancelButtonTitle:@"确定"
                          otherButtonTitles:nil, nil] show];
        [self.slider setHidden:YES];
        [self.memberAlbumContainView setHidden:YES];
        [self.navigationItem setRightBarButtonItem:nil];
    } failure:^(id req, NSError *error) {
        [[[UIAlertView alloc] initWithTitle:nil
                                    message:@"连接服务器失败"
                                   delegate:nil
                          cancelButtonTitle:@"确定"
                          otherButtonTitles:nil, nil] show];
        [self.slider setHidden:YES];
        [self.memberAlbumContainView setHidden:YES];
        [self.navigationItem setRightBarButtonItem:nil];
    }];
    
    [self.viewModel.signInResponse start:NO success:^(id response, GNActivitySignInModel *model) {
        __strongify;
        [SVProgressHUD showSuccessWithStatus:model.message];
        [self setHintViewHidden:YES];
    } error:^(id response, NSInteger code) {
        [self.slider setEnd:NO];
        [[[UIAlertView alloc] initWithTitle:nil
                                    message:[response objectForKey:@"message"]
                                   delegate:nil
                          cancelButtonTitle:@"确定"
                          otherButtonTitles:nil, nil] show];
    } failure:^(id req, NSError *error) {
        [self.slider setEnd:NO];
        [[[UIAlertView alloc] initWithTitle:nil
                                    message:@"连接服务器失败"
                                   delegate:nil
                          cancelButtonTitle:@"确定"
                          otherButtonTitles:nil, nil] show];
    }];
}

#pragma mark -

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.viewModel.signInInfo.check_list.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GNSignInCVC *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kUICellIdentifier forIndexPath:indexPath];
    
    GNActivitySignInItemModel *item = [self.viewModel.signInInfo.check_list objectAtIndex:indexPath.item];
    cell.numberLabel.text = [NSString stringWithFormat:@"%d",item.step];
    
    [self.slider setEnd:item.status];
    
    if (item.step == self.viewModel.signInInfo.step) {
        [self.slider setHidden:NO];
        [self setHintViewHidden:item.status];
    }else {
        [self.slider setHidden:!item.status];
        [self setHintViewHidden:YES];
    }
    
    return cell;
}

#pragma mark -

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}



@end
