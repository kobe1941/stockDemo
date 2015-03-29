//
//  HFHistogram.m
//  HFDrawPicture
//
//  Created by 胡峰 on 14-12-10.
//  Copyright (c) 2014年 胡峰. All rights reserved.
//

#import "HFHistogram.h"

@implementation HFHistogram

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.backgroundColor = [UIColor brownColor];
        
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [self drawHistogram];
}

#pragma mark - 画直方图
- (void)drawHistogram
{
    CGFloat pointX = 0;
    CGFloat width = self.gapWidth/2;
    
    for (int i = 0; i < self.dataPoints.count; i++)
    {
        CGFloat height = [self.dataPoints[i] floatValue];
        CGFloat pointY = self.frame.size.height - height;
        
        CGRect tempFrame = CGRectMake(pointX, pointY, width, height);
        
        UIColor *drawColor;
        if (height > 60)
        {
            drawColor = [UIColor redColor];
        } else
        {
            drawColor = [UIColor greenColor];
        }
        
        [self drawHistogramInRect:tempFrame fillColor:drawColor];
        
        pointX += self.gapWidth;
    }
}

#pragma mark - 画单个直方图的方法
- (void)drawHistogramInRect:(CGRect)aRect fillColor:(UIColor *)aColor
{
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(contextRef, aColor.CGColor);
    CGContextSetFillColorWithColor(contextRef, aColor.CGColor);
    CGContextAddRect(contextRef, aRect);
    
    CGContextFillPath(contextRef);
}

@end