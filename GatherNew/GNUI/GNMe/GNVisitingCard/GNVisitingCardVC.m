//
//  GNVisitingCardVC.m
//  GatherNew
//
//  Created by apple on 15/7/9.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNVisitingCardVC.h"
#import "UINavigationBar+GNExtension.h"
#import "UIControl+GNExtension.h"
#import "GNClubHomePageCVC.h"

@interface GNVisitingCardVC ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *topContainView;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewAvatar;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewGender;
@property (weak, nonatomic) IBOutlet UILabel *labelNickname;
@property (weak, nonatomic) IBOutlet UILabel *labelAge;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *btnSendMsg;

@end

@implementation GNVisitingCardVC

+ (NSString *)sbIdentifier {
    return @"visiting_card";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar lineViewHide:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar lineViewHide:NO];
    self.navigationController.navigationBar.barTintColor = kUIColorWithHexUint(GNUIColorGrayBlack);
}

- (void)setupUI {
    [super setupUI];
    
    UIColor *color = [GNApp colorWithGender:self.viewModel.gender];

    kUIAvatar(self.imageViewAvatar, [UIColor clearColor]);
    self.view.backgroundColor = kUIColorWithHexUint(GNUIColorWhite);
    self.labelNickname.textColor = kUIColorWithHexUint(GNUIColorWhite);
    self.labelAge.textColor = kUIColorWithHexUint(GNUIColorWhite);
    self.collectionView.backgroundColor = kUIColorWithHexUint(GNUIColorGrayWhite);
    [self.btnSendMsg setHidden:YES];
    [self.btnSendMsg setBackgroundColor:kUIColorWithHexUint(GNUIColorGreen) forState:UIControlStateNormal];
    [self.btnSendMsg setBackgroundColor:kUIColorWithHexUint(GNUIColorGreenPressed) forState:UIControlStateHighlighted];
    [self.topContainView setBackgroundColor:color];
    [self.navigationController.navigationBar setBarTintColor:color];
    [self.imageViewGender setImage:[GNApp imageWithGender:self.viewModel.gender]];
    
    self.labelNickname.text = @"";
    self.labelAge.text = @"";
}

- (void)binding {
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake((kUIScreenWidth-20)/3, (kUIScreenWidth-20)/3);
    layout.minimumInteritemSpacing = 2.5;
    layout.minimumLineSpacing = 5;
    layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    self.collectionView.collectionViewLayout = layout;
    [self.collectionView registerNib:[GNClubHomePageCVC nib] forCellWithReuseIdentifier:kUICellIdentifier];
    
    __weakify;
    void(^errorHandler)(void) = ^{
        __strongify;
        [self.view showHintViewWithType:XBHintViewTypeLoadError tapHandler:^(UIView *tapView) {
            __strongify;
            
            [self.view showHintViewWithType:XBHintViewTypeLoading tapHandler:nil];
            [self.viewModel.userInfoResponse start];
        }];
    };
    
    [self.viewModel.userInfoResponse start:YES success:^(id response, id model) {
        
        __strongify;
        [self.view hideHintView];
        [self.imageViewAvatar setUserAvatarImageWithURL:self.viewModel.model.avatar_url];
        [self.labelNickname setText:self.viewModel.model.nick_name];
        [self.labelAge setText:[GNApp ageFromDateString:self.viewModel.model.birthday]];
        [self.collectionView reloadData];
    } error:^(id response, NSInteger code) {
        errorHandler();
    } failure:^(id req, NSError *error) {
        errorHandler();
    }];
    [self.view showHintViewWithType:XBHintViewTypeLoading tapHandler:nil];
}

#pragma mark -

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.viewModel.model.tag_ids.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GNClubHomePageCVC *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kUICellIdentifier forIndexPath:indexPath];
    
    NSInteger interestId = [[self.viewModel.model.tag_ids objectAtIndex:indexPath.item] integerValue];
    cell.imageView.image = [GNApp imageWithInterestId:interestId];
    cell.titleLabel.text = [GNApp titleWithInterestId:interestId];
    
    return cell;
}

@end
