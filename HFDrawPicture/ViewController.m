//
//  ViewController.m
//  HFDrawPicture
//
//  Created by 胡峰 on 14-12-9.
//  Copyright (c) 2014年 胡峰. All rights reserved.
//

#import "ViewController.h"
#import "HFTestDrawView.h"
#import "HFHistogram.h"

#define kDeviceWidth   [UIScreen mainScreen].bounds.size.width
#define kDeviceHeight  [UIScreen mainScreen].bounds.size.height

#define kNumberOfTestPoints     25

@interface ViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *testPoints;

@property (nonatomic, strong) NSMutableArray *testKLineDatas;

@property (nonatomic, strong) HFTestDrawView *drawView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 50, kDeviceWidth-20, 400)];
    scrollView.backgroundColor = [UIColor lightGrayColor];
    scrollView.delegate = self;
    
    HFTestDrawView *drawView = [[HFTestDrawView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth-20, 200)];
    drawView.dataPoints = self.testPoints;
    drawView.kLineDatas = self.testKLineDatas;
    drawView.gapWidth = 15;
    drawView.startX = 10;
    self.drawView = drawView;
    
    
    CGRect tempFrame = drawView.frame;
    tempFrame.size.width = (self.testPoints.count-1)*drawView.gapWidth + 40;
    tempFrame.size.height = [self getMaxYWithArray:self.testPoints] * 2.5;
    drawView.frame = tempFrame;
    
    scrollView.contentSize = CGSizeMake(tempFrame.size.width, tempFrame.size.height);
    
    [scrollView addSubview:drawView];
    
    
    [self.view addSubview:scrollView];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - getter Methods
- (NSMutableArray *)testPoints
{
    if (!_testPoints)
    {
        _testPoints = [NSMutableArray array];
        
        // 测试数据
        for (int i = 0; i < kNumberOfTestPoints; i++)
        {
            CGFloat pointY = arc4random()%120 + 10;
            [_testPoints addObject:@(pointY)];
        }
        
    }
    
    return _testPoints;
}

#pragma mark -
- (NSMutableArray *)testKLineDatas
{
    if (!_testKLineDatas)
    {
        _testKLineDatas = [NSMutableArray array];
        
        NSString *startTime = @"20141201";
        for (int i = 0; i < kNumberOfTestPoints; i++)
        {
            NSMutableDictionary *mutableDic = [NSMutableDictionary dictionary];
            
            int time = [startTime intValue] + i;
            CGFloat maxPrice = 44;
            CGFloat minPrice = 8;
            CGFloat openPrice = 12;
            CGFloat closePrice = 11;
            
            [mutableDic setObject:[NSNumber numberWithInt:time] forKey:@"time"];
            [mutableDic setObject:[NSNumber numberWithFloat:maxPrice] forKey:@"maxPrice"];
            [mutableDic setObject:[NSNumber numberWithFloat:minPrice] forKey:@"minPrice"];
            [mutableDic setObject:[NSNumber numberWithFloat:openPrice] forKey:@"openPrice"];
            [mutableDic setObject:[NSNumber numberWithFloat:closePrice] forKey:@"closePrice"];
            
            
            [_testKLineDatas addObject:mutableDic];
        }
    }
    
    return _testKLineDatas;
}

#pragma mark - 获取最大值
- (CGFloat)getMaxYWithArray:(NSArray *)array
{
    CGFloat maxY = 0;
    
    for (NSNumber *number in array)
    {
        if ([number floatValue] > maxY)
        {
            maxY = [number floatValue];
        }
    }
    
    return maxY;
}
#pragma mark - 屏幕快照
- (UIImage *)screenShots
{
    UIGraphicsBeginImageContext(self.view.frame.size);
    
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *screenShot = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return screenShot;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    [self.drawView setNeedsDisplay];
}

@end