//
//  NTVColor.m
//  HKNTV
//
//  Created by JudeYou on 3/1/15.
//  Copyright (c) 2015 HKNTV. All rights reserved.
//

#import "NTVColor.h"

@implementation NTVColor

- (UIImage *)imageFromColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

@end