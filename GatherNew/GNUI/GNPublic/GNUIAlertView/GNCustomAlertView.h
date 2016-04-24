//
//  GNCustomAlertView.h
//  GatherNew
//
//  Created by yuanjun on 15/10/19.
//  Copyright © 2015年 ZERO TO ALL. All rights reserved.
//

#import <UIKit/UIKit.h>


@class GNCustomAlertView;

@protocol GNCustomAlertViewDelegate
@optional

- (void)GNCustomAlertView:(GNCustomAlertView *)customAlertView clickedButtonAtIndex:(NSInteger)buttonIndex;

@end

@interface GNCustomAlertView : UIView <GNCustomAlertViewDelegate>

@property (nonatomic, retain) UIView *parentView;    // The parent view this 'dialog' is attached to
@property (nonatomic, retain) UIView *dialogView;    // Dialog's container view
@property (nonatomic, retain) UIView *containerView; // Container within the dialog (place your ui elements here)

@property (nonatomic, assign) id<GNCustomAlertViewDelegate> delegate;
@property (nonatomic, retain) NSArray *buttonTitles;
@property (nonatomic, assign) BOOL useMotionEffects;
@property (nonatomic, assign) BOOL dismissTouchOutside;

- (id)init;

/*!
 DEPRECATED: Use the [CustomIOSAlertView init] method without passing a parent view.
 */
- (id)initWithParentView: (UIView *)_parentView __attribute__ ((deprecated));

- (void)show;
- (void)dismiss;


- (void)deviceOrientationDidChange: (NSNotification *)notification;

@end
