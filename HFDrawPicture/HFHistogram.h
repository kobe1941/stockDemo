//
//  HFHistogram.h
//  HFDrawPicture
//
//  Created by 胡峰 on 14-12-10.
//  Copyright (c) 2014年 胡峰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HFHistogram : UIView

@property (nonatomic, strong) NSArray *dataPoints;

@property (nonatomic, assign) CGFloat gapWidth; // 描点的X值间隔

@end
