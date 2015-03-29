//
//  HFTestDrawView.h
//  HFDrawPicture
//
//  Created by 胡峰 on 14-12-9.
//  Copyright (c) 2014年 胡峰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HFTestDrawView : UIView

@property (nonatomic, strong) NSArray *dataPoints;

@property (nonatomic, strong) NSArray *kLineDatas;

@property (nonatomic, assign) CGFloat gapWidth; // 描点的X值间隔

@property (nonatomic, assign) CGFloat startX; // 绘制的起始X值

@end