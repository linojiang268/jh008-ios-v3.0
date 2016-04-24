//
//  GNUIAppearance.h
//  GatherNew
//
//  Created by apple on 15/5/25.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#ifndef GatherNew_GNUIAppearance_h
#define GatherNew_GNUIAppearance_h

#import <UIKit/UIKit.h>
#import <UIColor+Hex.h>
#import <SVProgressHUD.h>


#define kUICellIdentifier @"Cell"
#define kUserLoginCount @"userLoginCount"

#define kUIScreenWidth [UIScreen mainScreen].bounds.size.width
#define kUIScreenHeight [UIScreen mainScreen].bounds.size.height

#define kUIColorWithHex(HEX) [UIColor colorWithCSS:HEX]
#define kUIColorWithHexUint(HEX) [UIColor colorWithHex:HEX]

#define kUIRoundCorner(view,border_color,border_width,corner_radius)         \
        view.layer.masksToBounds = YES;                                      \
        view.layer.borderColor = [border_color CGColor];                     \
        view.layer.borderWidth = border_width;                               \
        view.layer.cornerRadius = corner_radius;                             \

#define kUIAvatar(avatar_view,border_color) kUIRoundCorner(avatar_view, border_color, 3, CGRectGetWidth(avatar_view.bounds)/2)

#define kUIFontName @"DroidSansFallback"

typedef struct{
            long year;
            long mon;
            long day;
            long hour;
            long min;
            long sec;
        } DateTime;



#define ParseDateTime(STRING, DT) \
            sscanf(STRING, "%ld-%ld-%ld %ld:%ld:%ld", &DT.year, &DT.mon, &DT.day, &DT.hour, &DT.min, &DT.sec);

typedef NS_ENUM(NSUInteger, GNUIFontSize) {
    GNUIFontSize22  = 22,
    GNUIFontSize18  = 18,
    GNUIFontSize16  = 16,
    GNUIFontSize14  = 14,
    GNUIFontSize12  = 12
};

typedef NS_ENUM(NSUInteger, GNUIColor) {
    GNUIColorOrange         = 0xfffd7037,
    GNUIColorOrangePressed  = 0xffe6581f,
    GNUIColorBlue           = 0xff00a9e8,
    GNUIColorBluePressed    = 0xff0196ce,
    GNUIColorYellow         = 0xfffdce1e,
    GNUIColorYellowPressed  = 0xffedbf13,
    GNUIColorGreen          = 0xff52be7f,
    GNUIColorGreenPressed   = 0xff44ae70,
    GNUIColorWhite          = 0xffffffff,
    GNUIColorGrayWhite      = 0xffeef2f4,
    GNUIColorGray           = 0xffc5d2d8,
    GNUIColorBlack          = 0xff333333,
    GNUIColorDarkgray       = 0xff999999,
    GNUIColorGrayBlack      = 0xff333742,
    GNUIColorDisabled       = 0xffd2d2d2,
    GNUIColorPlaceholder    = 0xffcccccc
};

#endif
