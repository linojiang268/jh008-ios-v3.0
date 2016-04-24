//
//  ViewController.m
//  GatherNew
//
//  Created by apple on 15/5/25.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNViewController.h"

#import <Masonry.h>
#import "GNGalleryController.h"
#import "GNLocationService.h"
#import "UIView+GNExtension.h"
#import "GNChooseImageService.h"
#import "UIView+XBHintViewExtension.h"

@interface GNViewController ()

@end

@implementation GNViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.view.backgroundColor = [UIColor yellowColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton *itemButton1 = [[UIButton alloc] init];
    [itemButton1 setTitle:@"PhotoBrwser" forState:UIControlStateNormal];
    [itemButton1 addTarget:self action:@selector(itemButton1) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:itemButton1];
    
    UIButton *itemButton2 = [[UIButton alloc] init];
    [itemButton2 setTitle:@"Location" forState:UIControlStateNormal];
    [itemButton2 addTarget:self action:@selector(itemButton2) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:itemButton2];
    
    UIButton *itemButton3 = [[UIButton alloc] init];
    [itemButton3 setTitle:@"ChooseImage" forState:UIControlStateNormal];
    [itemButton3 addTarget:self action:@selector(itemButton3) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:itemButton3];
    
    [itemButton1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@50);
        make.leading.equalTo(@50);
        make.height.equalTo(@100);
        make.width.equalTo(@200);
    }];
    
    [itemButton2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@50);
        make.leading.equalTo(@200);
        make.height.equalTo(@100);
        make.width.equalTo(@100);
    }];
    
    [itemButton3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@200);
        make.leading.equalTo(@50);
        make.height.equalTo(@100);
        make.width.equalTo(@100);
    }];
}

- (void)itemButton1 {
    MHGalleryItem *landschaft = [MHGalleryItem.alloc initWithURL:@"http://alles-bilder.de/landschaften/HD%20Landschaftsbilder%20(47).jpg"
                                                     galleryType:MHGalleryTypeImage];
    
    MHGalleryItem *landschaft1 = [MHGalleryItem.alloc initWithURL:@"http://de.flash-screen.com/free-wallpaper/bezaubernde-landschaftsabbildung-hd/hd-bezaubernde-landschaftsder-tapete,1920x1200,56420.jpg"
                                                      galleryType:MHGalleryTypeImage];
    
    MHGalleryItem *landschaft2 = [MHGalleryItem.alloc initWithURL:@"http://alles-bilder.de/landschaften/HD%20Landschaftsbilder%20(64).jpg"
                                                      galleryType:MHGalleryTypeImage];
    
    MHGalleryItem *landschaft3 = [MHGalleryItem.alloc initWithURL:@"http://www.dirks-computerseite.de/wp-content/uploads/2013/06/purpleworld1.jpg"
                                                      galleryType:MHGalleryTypeImage];
    
    MHGalleryItem *landschaft4 = [MHGalleryItem.alloc initWithURL:@"http://alles-bilder.de/landschaften/HD%20Landschaftsbilder%20(42).jpg"
                                                      galleryType:MHGalleryTypeImage];
    
    MHGalleryItem *landschaft5 = [MHGalleryItem.alloc initWithURL:@"http://woxx.de/wp-content/uploads/sites/3/2013/02/8X2cWV3.jpg"
                                                      galleryType:MHGalleryTypeImage];
    
    GNGalleryController *controller = [GNGalleryController galleryControllerWithAlbum:@[landschaft,landschaft1,landschaft2,landschaft3,landschaft4,landschaft5] defaultIndex:0];
    
    __weak GNGalleryController *blockGallery = controller;
    [controller finishedCallback:^(NSInteger currentIndex, UIImage *image, MHTransitionDismissMHGallery *interactiveTransition, MHGalleryViewMode viewMode) {
        [blockGallery dismissViewControllerAnimated:YES dismissImageView:nil completion:^{
            
        }];
    }];

    [self presentMHGalleryController:controller animated:YES completion:^{
        
    }];
}

- (void)itemButton2 {
    [GNLocationService requestPlacemarkWithBlock:^(CLPlacemark *placemark, GNCityModel *city, INTULocationStatus status) {
        
    }];
}

- (void)itemButton3 {
//    [GNChooseImageService chooseImageWithController:self finishedBlock:^(UIImage *image) {
//        
//    }];
    
    [self.view showHintViewWithType:XBHintViewTypeNoData tapHandler:^(UIView *tapView) {
        [tapView.superview showHintViewWithType:XBHintViewTypeLoading tapHandler:^(UIView *tapView) {
            [tapView.superview hideHintView];
        }];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
