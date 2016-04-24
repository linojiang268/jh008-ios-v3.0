//
//  GNInterestTagVC.m
//  GatherNew
//
//  Created by apple on 15/6/11.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNInterestTagVC.h"
#import "UIControl+GNExtension.h"
#import "GNPerfectInfoVC.h"
#import "GNInterestTagNPS.h"
#import "GNInterestTagCell.h"
#import "GNPerfectInfoVC.h"

@interface GNInterestTagVC ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property(nonatomic, strong) NSMutableArray* arraySelected;
@property(nonatomic, assign) BOOL ctxFromPerfectInfo;
@property(nonatomic, strong) NSString* phone;
@property(nonatomic, strong) NSString* password;
@end

@implementation GNInterestTagVC

+ (NSString *)sbIdentifier {
    return @"interest_tag";
}


+ (instancetype)initPerfectInfoWithPhone:(NSString*)phone password:(NSString*)password {
    GNInterestTagVC *controller = [GNInterestTagVC loadFromStoryboard];
    controller.ctxFromPerfectInfo = YES;
    controller.phone = phone;
    controller.password = password;
    return controller;
}

- (void)setupUI {
    
    [super setupUI];
    
    [self.lbTitle setTextColor:kUIColorWithHexUint(GNUIColorDarkgray)];
    
    self.arraySelected = [NSMutableArray array];

    if (self.arrayTags.count>0) {
        self.navigationItem.rightBarButtonItem  = nil;
    }
    
    self.navigationController.navigationBar.hidden = NO;

    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([GNInterestTagCell class]) bundle:nil] forCellWithReuseIdentifier:@"GNInterestTagCell"];

    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    UIImage *imageReturn =[UIImage imageNamed:@"nav_return"];
    imageReturn = [imageReturn imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:imageReturn style:UIBarButtonItemStylePlain target:self action:@selector(backBarButtonItemPressed:)];

    
    if (self.arrayTags!=nil && self.arrayTags.count>0) {
        [self.arraySelected removeAllObjects];
        [self.arraySelected addObjectsFromArray:self.arrayTags];
        [self.collectionView reloadData];
    }

}

- (GNBackButtonType)backButtonType {
    return GNBackButtonTypeNone;
}

-(void)backBarButtonItemPressed:(UIBarButtonItem *)sender{
    if (self.getInterestTagValue!=nil) {
        self.getInterestTagValue(self.arraySelected);
    }

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"into_PerfectInfo"]) {
        if (self.arraySelected.count==0) {
            [SVProgressHUD showInfoWithStatus:@"请选择您的兴趣!"];
            return;
        }
        ((GNPerfectInfoVC *)segue.destinationViewController).tagIds = self.arraySelected;
    }
}

#pragma mark -- UICollectionViewDataSource
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 12;
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"GNInterestTagCell";
    GNInterestTagCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];

    NSString *arrayValue = [NSString stringWithFormat:@"%ld",indexPath.row+1];
    BOOL flag = [self.arraySelected containsObject:arrayValue];
    if (flag) {
        [cell isSelected:YES selectedId:indexPath.row+1];
    }else{
         [cell isSelected:NO selectedId:indexPath.row+1];
    }

    return cell;
} 
#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    float width = [UIScreen mainScreen].bounds.size.width;
    float simpleCellW = width/2-16;
    
    return CGSizeMake(simpleCellW, 111);
}
//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 10, 6, 10);
}
#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *arrayValue = [NSString stringWithFormat:@"%ld",indexPath.row+1];
   BOOL flag = [self.arraySelected containsObject:arrayValue];
    if (flag) {
        [self.arraySelected removeObject:arrayValue];
    }
    else{
        [self.arraySelected addObject:arrayValue];
    }
    
    [self.collectionView reloadData];
}
//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (IBAction)btnNextAction:(id)sender {
    if (self.arraySelected.count == 0) {
        [SVProgressHUD showInfoWithStatus:@"请选择您的兴趣!"];
        return;
    }
    
    GNPerfectInfoVC *vc = [GNPerfectInfoVC loadFromStoryboard];
    vc.tagIds = self.arraySelected;
    if(self.ctxFromPerfectInfo){
        vc.phone = self.phone;
        vc.password = self.password;
    }
    
    [self.navigationController pushVC:vc animated:YES];
}
@end
