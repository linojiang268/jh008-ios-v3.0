//
//  GNActivityAlbumUploadVM.m
//  GatherNew
//
//  Created by apple on 15/7/28.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNActivityAlbumUploadVM.h"
#import "UIImage+ImageCompress.h"

@interface GNActivityAlbumUploadVM ()

@property (nonatomic, assign) NSUInteger index;

@end

@implementation GNActivityAlbumUploadVM

- (instancetype)initWithActivityId:(NSUInteger)activityId {
    self = [super init];
    if (self) {
        self.activityId = activityId;
    }
    return self;
}

- (NSMutableArray *)photosArray {
    if (!_photosArray) {
        _photosArray = [[NSMutableArray alloc] init];
    }
    return _photosArray;
}

- (BOOL)isEnd {
    return self.index == self.photosArray.count;
}

- (void)initModel {
    __weakify;
    self.uploadResponse = [GNVMResponse responseWithTaskBlock:^{
        __strongify;
        self.index = 0;
        [self upload];
    }];
}


- (void)upload {
    UIImage *image = [self.photosArray objectAtIndex:self.index];
    NSData *data = [UIImage dataCompressImage:image compressRatio:0.75 maxCompressRatio:0.1];
    
    GNNPSBase *nps = [[GNNPSBase alloc] initWithURL:@"/api/activity/album/image/add"];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:kNumber(self.activityId) forKey:@"activity"];
    [params setObject:[nps createSign:params] forKey:@"sign"];
    
    [nps setParameters:params];
    [nps setFormData:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:data name:@"image" fileName:@"img.jpg" mimeType:@"image/jpg"];
    }];
    
    __weakify;
    [GNNetworkService POSTWithService:nps success:^(id response, id model) {
        __strongify;
        [self.photosArray removeObjectAtIndex:self.index];
        if (self.index < self.photosArray.count) {
            [self upload];
        }
        self.uploadResponse.success(response, model);
    } error:^(id response, NSInteger code) {
        __strongify;
        self.index++;
        if (self.index < self.photosArray.count) {
            [self upload];
        }else {
            self.uploadResponse.success(nil, nil);
        }
    } failure:self.uploadResponse.failure];
}

@end
