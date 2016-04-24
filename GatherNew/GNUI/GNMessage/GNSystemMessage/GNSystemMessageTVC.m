//
//  GNSystemMessageTVC.m
//  GatherNew
//
//  Created by apple on 15/8/5.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNSystemMessageTVC.h"
#import "GNMessageModel.h"
#import <CoreData+MagicalRecord.h>

@interface GNSystemMessageTVC ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (nonatomic, copy) void(^deleteCallback)(id model);

@end

@implementation GNSystemMessageTVC

- (void)awakeFromNib {
    [self setReadState:NO];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)delete:(id)sender {
    if (self.model) {
        
        GNMessageModel *model = self.model;
        [model MR_deleteEntity];
        if (self.deleteCallback) {
            self.deleteCallback(self.model);
        }
    }
}

- (void)deleteWithCallback:(void(^)(id model))callback
{
    self.deleteCallback = callback;
}

- (void)setReadState:(BOOL)read {
    if (read) {
        self.titleLabel.textColor = kUIColorWithHexUint(0xFF9D9D9D);
        self.dateLabel.textColor = kUIColorWithHexUint(0xFF9D9D9D);
        if (self.model) {
            GNMessageModel *model = self.model;
            model.is_read = YES;
            [[NSManagedObjectContext MR_defaultContext] MR_saveOnlySelfWithCompletion:^(BOOL success, NSError *error) {
                
            }];
        }
    }else {
        self.titleLabel.textColor = kUIColorWithHexUint(0xFF545452);
        self.dateLabel.textColor = kUIColorWithHexUint(0xFF9D9D9D);
    }
}

- (void)bindingModel:(GNMessageModel *)model {
    [super bindingModel:model];
    [self setReadState:model.is_read];
    
    self.titleLabel.text = model.content;
    self.dateLabel.text = model.create_at;
}

@end
