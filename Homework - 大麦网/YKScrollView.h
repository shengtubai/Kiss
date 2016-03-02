//
//  YKScrollView.h
//  无限循环滚动备课
//
//  Created by gouyuankai on 16/1/4.
//  Copyright © 2016年 GYK. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YKScrollView;

@protocol YKCycleScrollViewDelegate <NSObject>

// 代理方法 通知代理方点击的下标
- (void)cycleScrollView:(YKScrollView *)cycleScrollView DidTapImageView:(NSInteger)index;

@end


@interface YKScrollView : UIView


@property (nonatomic, weak) id<YKCycleScrollViewDelegate> delegate;

//外部传来图片 和时间
- (void)setImageNames:(NSArray *)imageNames animationDuration:(NSTimeInterval)animationDuration;

// 内部使用的是系统默认的pageControll属性 如有需要 自行设置
@property (nonatomic ,weak) UIPageControl *scrollPage;
@end
