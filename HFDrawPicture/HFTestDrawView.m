//
//  HFTestDrawView.m
//  HFDrawPicture
//
//  Created by 胡峰 on 14-12-9.
//  Copyright (c) 2014年 胡峰. All rights reserved.
//

#import "HFTestDrawView.h"

@implementation HFTestDrawView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.backgroundColor = [UIColor grayColor];
       
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [self drawBackGroundBaseLine];
    
    
    [self drawTrendLineGraph];
    [self fillTrendLineGraph];
    
    [self drawHistogram];
    
    [self drawString:@"呵呵呵" inRect:CGRectMake(20, 165, 60, 20)];
    
    
    [self drawKLineGraph];
}

#pragma mark - setter Mehtods
- (void)setDataPoints:(NSArray *)dataPoints
{
    _dataPoints = dataPoints;
    
    // 重绘
//    [self setNeedsDisplay];
}

#pragma mark - 测试
- (void)justTest
{
    [self drawRectangle];
    [self drawString:@"ahhahhah"];
    [self drawLineMethodThird];
    [self drawCircleMethodSecond];
    [self drawCurve];
    [self drawGradualChange];
}


#pragma mark - 绘画的函数
#pragma mark - 画k线图

- (void)drawKLineGraph
{
    CGFloat lineWidth = 2;
    CGFloat rectangleW = 6;
    CGFloat startX = self.startX;
    // 先画线，再画框
    for (NSDictionary *dic in self.kLineDatas)
    {
        int time = [[dic objectForKey:@"time"] intValue];
        CGFloat maxPrice = [[dic objectForKey:@"maxPrice"] floatValue];
        CGFloat minPrice = [[dic objectForKey:@"minPrice"] floatValue];
        CGFloat openPrice = [[dic objectForKey:@"openPrice"] floatValue];
        CGFloat closePrice = [[dic objectForKey:@"closePrice"] floatValue];
        
        
        
        CGPoint startPoint = CGPointMake(startX, minPrice);
        CGPoint endPoint = CGPointMake(startX, maxPrice);
        
        [self drawOneRealLineAtStartPoint:startPoint toEndPoint:endPoint withColor:[UIColor redColor]];
        
        CGRect tempRect = CGRectMake(startX-rectangleW/2, openPrice, rectangleW, abs(openPrice - closePrice) + 5);
        
        [self drawOneRectangleInRect:tempRect withColor:[UIColor redColor]];
        
        startX += self.gapWidth;
    }
    
}

- (void)drawOneRealLineAtStartPoint:(CGPoint)aStartPoint toEndPoint:(CGPoint)aEndPoint withColor:(UIColor *)aColor
{
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(contextRef, 2);
    CGContextSetLineCap(contextRef, kCGLineCapRound);
    CGContextSetStrokeColorWithColor(contextRef, aColor.CGColor);
    CGContextBeginPath(contextRef);
    
    CGContextMoveToPoint(contextRef, aStartPoint.x, aStartPoint.y);
    CGContextAddLineToPoint(contextRef, aEndPoint.x, aEndPoint.y);
    CGContextStrokePath(contextRef);
}

- (void)drawOneRectangleInRect:(CGRect)aRect withColor:(UIColor *)aColor
{
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(contextRef, aColor.CGColor);
    
    CGContextAddRect(contextRef, aRect);
    
    CGContextDrawPath(contextRef, kCGPathFill);
}

#pragma mark - 画股票走势图
- (void)drawTrendLineGraph
{
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(contextRef, 1);
    CGContextSetLineJoin(contextRef, kCGLineJoinRound); // 线之间连接处为圆角
    CGContextSetLineCap(contextRef, kCGLineCapRound); // 线的头尾的样式
    CGContextSetStrokeColorWithColor(contextRef, [UIColor greenColor].CGColor);
    // 起始点
    CGContextBeginPath(contextRef);
    
    CGFloat pointX = self.startX; // 起始X值
    for (int i = 0; i < self.dataPoints.count; i++)
    {
        CGFloat pointY = self.frame.size.height/2 - [self.dataPoints[i] floatValue];
        
        if (i == 0)
        {
            CGContextMoveToPoint(contextRef, pointX, pointY);
        } else
        {
            CGContextAddLineToPoint(contextRef, pointX, pointY);
        }
        
        pointX += self.gapWidth;
        
    }
    
    CGContextStrokePath(contextRef);
}

- (void)fillTrendLineGraph
{
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(contextRef, 0); // 宽度设为0，直接填充
    CGContextSetLineJoin(contextRef, kCGLineJoinRound); // 线之间连接处为圆角
    CGContextSetLineCap(contextRef, kCGLineCapRound); // 线的头尾的样式
    CGContextSetStrokeColorWithColor(contextRef, [UIColor greenColor].CGColor);
    // 起始点
    CGContextBeginPath(contextRef);
    
    CGFloat pointX = self.startX;
    CGFloat originX = pointX;
    CGFloat originY = self.frame.size.height/2 - [self.dataPoints[0] floatValue];
    for (int i = 0; i < self.dataPoints.count; i++)
    {
        CGFloat pointY = self.frame.size.height/2 - [self.dataPoints[i] floatValue];
        
        if (i == 0)
        {
            CGContextMoveToPoint(contextRef, pointX, pointY);
        } else
        {
            CGContextAddLineToPoint(contextRef, pointX, pointY);
        }
        
        pointX += self.gapWidth;
        
    }
    
    
    CGContextAddLineToPoint(contextRef, pointX-self.gapWidth, self.frame.size.height/2);
    CGContextAddLineToPoint(contextRef, originX, self.frame.size.height/2);
    CGContextAddLineToPoint(contextRef, originX, originY);
    
    const CGFloat array[] = {0,0,1,0.2};
    CGContextSetFillColor(contextRef, array);
    CGContextDrawPath(contextRef, kCGPathFillStroke);
}

#pragma mark - 画虚线
- (void)drawDashLineWithStartPoint:(CGPoint)aStartPoint endPoint:(CGPoint)aEndPoint
{
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextBeginPath(contextRef);
    CGContextSetLineWidth(contextRef, 1);
    
    CGContextSetStrokeColorWithColor(contextRef, [UIColor yellowColor].CGColor);
    
    CGFloat lengths[] = {10,10};
    CGContextSetLineDash(contextRef, 0, lengths, 2); // 第二个参数为相位
    
    CGContextMoveToPoint(contextRef, aStartPoint.x, aStartPoint.y);
    CGContextAddLineToPoint(contextRef, aEndPoint.x, aEndPoint.y);
    
    CGContextStrokePath(contextRef);
}

#pragma mark - 画字符串
- (void)drawString:(NSString *)aString
{
    [self drawString:aString inRect:CGRectMake(20, 20, 100, 40)];
}

- (void)drawString:(NSString *)aString inRect:(CGRect)aRect
{
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(contextRef, 1);
    
    UIFont *font = [UIFont boldSystemFontOfSize:14];
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0)
    {
        NSDictionary *attribute = @{NSFontAttributeName : font,
                                    NSForegroundColorAttributeName : [UIColor redColor],
                                    NSBackgroundColorAttributeName : [UIColor greenColor]};
        [aString drawInRect:aRect withAttributes:attribute];
        
    }
}

#pragma mark - 画直方图
- (void)drawHistogram
{
    CGFloat pointX = self.startX;
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

#pragma mark - 绘制背景基准线
- (void)drawBackGroundBaseLine
{
    [self drawRealHorizontalLine];
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    // Pushes a copy of the current graphics state onto the graphics state stack for the context.
    CGContextSaveGState(contextRef);
    
    [self drawDashVerticaLine];
    
    CGContextRestoreGState(contextRef);
}

/**
 *  水平实线
 */
- (void)drawRealHorizontalLine
{
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(contextRef, 0.5);
    CGContextSetStrokeColorWithColor(contextRef, [UIColor blackColor].CGColor);
    
    CGFloat startX = self.startX;
    CGFloat startY = 20;
//    CGFloat height = self.frame.size.height - startY;
    CGFloat width = self.frame.size.width - startX*2;
    CGContextAddRect(contextRef, CGRectMake(startX, startY, self.frame.size.width-startX*2, self.frame.size.height-startY));
    
    
    // 画横线
    startX = self.startX;
    CGFloat gapDrawY = self.gapWidth*4;
    while (startY < self.frame.size.height)
    {
        startY += gapDrawY;
        if ((startY + gapDrawY) > self.frame.size.height)
        {
            break;
        }
        
        CGContextMoveToPoint(contextRef, startX, startY);
        CGContextAddLineToPoint(contextRef, startX+width, startY);
    }
    
    CGContextStrokePath(contextRef);
}

/**
 *  竖直虚线
 */
- (void)drawDashVerticaLine
{
    CGFloat startX = self.startX;
    CGFloat startY = 20;
    CGFloat height = self.frame.size.height - startY;
//    CGFloat width = self.frame.size.width - startX*2;
    
    // 画竖线
    CGFloat gapDrawX = self.gapWidth*8;
    while (startX < self.frame.size.width)
    {
        startX += gapDrawX;
        
        if ((startX + gapDrawX) > self.frame.size.width)
        {
            break;
        }
        
        [self drawDashLineWithStartPoint:CGPointMake(startX, startY) endPoint:CGPointMake(startX, startY+height)];
        
    }

}


#pragma mark - 测试用的方法
#pragma mark - 画实线
- (void)drawLineMethodFirst
{
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(contextRef, 1);
    [[UIColor redColor] set];
    
    CGContextMoveToPoint(contextRef, 10, 10);
    CGContextAddLineToPoint(contextRef, 100, 10);
    CGContextAddLineToPoint(contextRef, 100, 50);
    CGContextAddLineToPoint(contextRef, 10, 50);
    
    CGContextClosePath(contextRef);
    CGContextDrawPath(contextRef, kCGPathStroke);
}

- (void)drawLineMethodSecond
{
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(contextRef, 1);
    
    //    CGContextBeginPath(contextRef); // 声明绘画开始
    CGContextMoveToPoint(contextRef, 10, 10);
    CGContextAddLineToPoint(contextRef, 100, 10);
    CGContextAddLineToPoint(contextRef, 100, 50);
    CGContextAddLineToPoint(contextRef, 10, 50);
    
    CGFloat redColor[4] = {1,0,0,1}; // 四个值对应红绿蓝和alpha.
    CGContextSetStrokeColor(contextRef, redColor);
    CGContextStrokePath(contextRef);
}

- (void)drawLineMethodThird
{
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(contextRef, 4);
    CGContextSetRGBStrokeColor(contextRef, 1, 1, 0, 1);
    CGContextMoveToPoint(contextRef, 180, 80);
    CGContextAddLineToPoint(contextRef, 190, 110);
    
    CGContextStrokePath(contextRef);
}



#pragma mark - 画一个圆
- (void)drawCircleMethodFirst
{
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(contextRef, 5);
    [[UIColor yellowColor] set];
    
    CGContextAddEllipseInRect(contextRef, CGRectMake(150, 50, 50, 50));
    CGContextSetFillColorWithColor(contextRef, [UIColor greenColor].CGColor);
    CGContextDrawPath(contextRef, kCGPathFillStroke);
}

- (void)drawCircleMethodSecond
{
    UIBezierPath *bezier = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(200, 50, 50, 50)];
    
    [[UIColor blueColor] setFill];
    
    [bezier fill];
}

#pragma mark - 画一个框
- (void)drawRectangle
{
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(contextRef, 0, 0, 1, 1);
    CGContextSetLineWidth(contextRef, 5);
    
    
    CGContextAddRect(contextRef, CGRectMake(50, 50, 100, 100));
    
    // 只画线
    CGContextStrokePath(contextRef);
    
    // 画线和填充一起
    //    CGContextSetRGBFillColor(contextRef, 1, 0, 0, 1);
    //    CGContextDrawPath(contextRef, kCGPathFillStroke);
}


#pragma mark - 画曲线
- (void)drawCurve
{
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    
    CGContextBeginPath(contextRef);
    
    CGContextMoveToPoint(contextRef, 200, 150);
    
    CGContextAddQuadCurveToPoint(contextRef, 250, 130, 280, 50);
    
    CGContextSetLineWidth(contextRef, 4);
    
    CGContextSetStrokeColorWithColor(contextRef, [UIColor brownColor].CGColor);
    
    CGContextStrokePath(contextRef);
    
}

#pragma mark - 渐变颜色
- (void)drawGradualChange
{
    CGRect tempFrame = CGRectMake(50, 50, 100, 100);
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    
    
    NSArray *colors = @[(__bridge id)[UIColor redColor].CGColor,(__bridge id)[UIColor greenColor].CGColor];
    
    const CGFloat locations[] = {0.0,1.0};
    
    CGGradientRef gradientRef = CGGradientCreateWithColors(colorSpaceRef, (__bridge CFArrayRef)colors, locations);
    
    CGPoint startPoint = CGPointMake(CGRectGetMinX(tempFrame), CGRectGetMinY(tempFrame));
    CGPoint endPoint = CGPointMake(CGRectGetMaxX(tempFrame), CGRectGetMaxY(tempFrame));
    
    
    CGContextSaveGState(contextRef);
    CGContextAddRect(contextRef, tempFrame);
    CGContextClip(contextRef);
    CGContextDrawLinearGradient(contextRef, gradientRef, startPoint, endPoint, 0);
    CGContextRestoreGState(contextRef);
    
    // 释放资源
    CGGradientRelease(gradientRef);
    CGColorSpaceRelease(colorSpaceRef);
    
}


#pragma mark - 其他
- (void)drawAttention
{
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    /**
     *  1.
     *  在用context之前需要push下，最后再pop，这样就不会破坏外面的context，随便我在里面做什么。
     */
    UIGraphicsPushContext(contextRef);
    /**
     *  anything you want to draw
     */
    UIGraphicsPopContext();
    
    /**
     *  2.
     */
    CGContextSaveGState(contextRef);
    /**
     *  anything you want to do
     */
    CGContextRestoreGState(contextRef);

}

- (void)anotherMethosToGetContextRef
{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(100, 100), NO, 0);
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    
    /**
     *  continue to do something with contextRef
     */
    
}

@end