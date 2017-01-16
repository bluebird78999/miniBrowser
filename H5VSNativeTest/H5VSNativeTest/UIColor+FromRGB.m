//
//  UIColor+FromRGB.m
//   
//
//  Created by 董蕾 on 11-11-27.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "UIColor+FromRGB.h"

@implementation UIColor (FromRGB)

+(UIColor*)colorWithRed:(CGFloat)red Green:(CGFloat)green  Blue:(CGFloat)blue  alpha:(CGFloat)alpha
{
    CGFloat redF    = red/255;
    CGFloat greenF    = green/255;
    CGFloat blueF    = blue/255;
    CGFloat alphaF    = alpha/1.0;
    
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    CGFloat components[4] = {redF, greenF, blueF, alphaF};
    CGColorRef color = CGColorCreate(colorspace, components);
    UIColor *resultColor = [UIColor colorWithCGColor:color];
    CGColorRelease(color);
    CGColorSpaceRelease(colorspace);
    
    return resultColor;    
}

+ (UIColor *)colorFromRGB:(NSInteger)rgbValue withAlpha:(CGFloat)alpha 
{
    return [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 
                           green:((float)((rgbValue & 0xFF00) >> 8))/255.0 
                            blue:((float)(rgbValue & 0xFF))/255.0 alpha:alpha];
    
}

+ (UIColor *)colorFromRGB:(NSInteger)rgbValue
{
    return [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 
                           green:((float)((rgbValue & 0xFF00) >> 8))/255.0 
                            blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0];
    
}

/**
 * hexString eg. #ff0000
 */
+ (UIColor *)colorWithHexString:(NSString *)hexString
{
    return [UIColor colorWithHexString:hexString Alpha:1.0f];
}

+ (UIColor *)colorWithHexString:(NSString *)hexString Alpha:(CGFloat)alpha
{
    
    NSString* cString = [[hexString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
	
	// String should be 6 or 8 characters
	if ([cString length] < 6) return [UIColor blackColor];
	
	// strip 0X if it appears
	if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
	if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
	
	if ([cString length] != 6) return [UIColor blackColor];
	
	// Separate into r, g, b substrings
	NSRange range;
	range.location = 0;
	range.length = 2;
	NSString* rString = [cString substringWithRange:range];
	
	range.location = 2;
	NSString* gString = [cString substringWithRange:range];
	
	range.location = 4;
	NSString* bString = [cString substringWithRange:range];
    
    // Scan values
	unsigned int r, g, b;
	[[NSScanner scannerWithString:rString] scanHexInt:&r];
	[[NSScanner scannerWithString:gString] scanHexInt:&g];
	[[NSScanner scannerWithString:bString] scanHexInt:&b];
	
	return [UIColor colorWithRed:((float) r / 255.0f)
						   green:((float) g / 255.0f)
							blue:((float) b / 255.0f)
						   alpha:alpha];
}

@end
