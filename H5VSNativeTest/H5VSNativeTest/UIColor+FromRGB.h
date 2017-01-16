//
//  UIColor+FromRGB.h
//   
//
//  Created by 董蕾 on 11-11-27.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (FromRGB)

+ (UIColor*)colorWithRed:(CGFloat)red Green:(CGFloat)green  Blue:(CGFloat)blue  alpha:(CGFloat)alpha;
+ (UIColor *)colorFromRGB:(NSInteger)rgbValue withAlpha:(CGFloat)alpha;
+ (UIColor *)colorFromRGB:(NSInteger)rgbValue;

+ (UIColor *)colorWithHexString:(NSString *)hexString;
+ (UIColor *)colorWithHexString:(NSString *)hexString Alpha:(CGFloat)alpha;

@end
