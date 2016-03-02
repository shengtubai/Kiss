//
//  YKScrollView.m
//  无限循环滚动备课
//
//  Created by gouyuankai on 16/1/4.
//  Copyright © 2016年 GYK. All rights reserved.
//

#import "YKScrollView.h"
#import "HeadView.h"
#import "UIImageView+WebCache.h"
@interface YKScrollView()<UIScrollViewDelegate>

@property(nonatomic,strong)HeadView * model;
//主scorllView
@property (nonatomic, weak) UIScrollView *cycleScrollView;

@property(nonatomic,strong)UILabel * label;

//当前页码数
@property (nonatomic, assign) NSInteger currentPageIndex;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) NSMutableArray *imageNames;


@property (nonatomic, strong) NSMutableArray *contentImages;

@end

@implementation YKScrollView


- (void)dealloc
{
    [self.timer invalidate];
}


- (NSMutableArray *)imageNames
{
    if (_imageNames == nil) {
        _imageNames = [[NSMutableArray alloc] init];
    }
    return _imageNames;
}
- (NSMutableArray *)contentImages
{
    if (_contentImages == nil) {
        _contentImages = [[NSMutableArray alloc] init];
    }
    return _contentImages;
}


//关于大小
- (instancetype)initWithFrame:(CGRect)frame
{
    
    //自己大小
    self = [super initWithFrame:frame];
    
    if (self) {
        
        //内部子空间
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        
        self.cycleScrollView = scrollView;
        
        
        //设置代理
        self.cycleScrollView.delegate = self;
        
        //不能弹
        self.cycleScrollView.bounces = NO;
        
        self.cycleScrollView.pagingEnabled = YES;
        
        //设置滑动边界
        self.cycleScrollView.contentSize = CGSizeMake(3 * CGRectGetWidth(self.cycleScrollView.frame), CGRectGetHeight(self.cycleScrollView.frame));
        
        //当前也初始值为0
        self.currentPageIndex = 0;
        
        [self addSubview:self.cycleScrollView];
        
        //刷新位置 初始化位置设置为1中间
        
        
        //添加三章imageView
        [self addThreeImageView];
        
        [self createLabel];
        [self refreshLocation];
        
        //创建pageControl
        UIPageControl *page = [[UIPageControl alloc] init];
        [self addSubview:page];
        page.currentPageIndicatorTintColor = [UIColor colorWithRed:250/255.f green:78/255.f blue:70/255.f alpha:1];
        page.pageIndicatorTintColor = [UIColor whiteColor];
        page.alpha = 0.8;
        
        self.userInteractionEnabled = YES;
        self.cycleScrollView.userInteractionEnabled = NO;
        self.scrollPage = page;
        
    }
    
    return self;
}

- (void)createLabel
{
   self.label = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.frame)- 30, self.frame.size.width, 30)];
    self.label.backgroundColor = [UIColor blackColor];
    self.label.alpha = 0.8;
    self.label.textColor = [UIColor whiteColor];
    [self addSubview:self.label];
}
//添加三个imageView
- (void)addThreeImageView{

    //移除每个视图
    for (UIView *view in self.cycleScrollView.subviews) {
        [view removeFromSuperview];
    }
    
    //创建三个imageView
    for (int i = 0; i < 3; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        
        CGFloat W = CGRectGetWidth(self.cycleScrollView.frame);
        CGFloat H = CGRectGetHeight(self.cycleScrollView.frame);
        
        imageView.frame = CGRectMake(i * W, 0, W, H);
        imageView.userInteractionEnabled = YES;
        //添加手势
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTapAction:)];
        [imageView addGestureRecognizer:tapGesture];
        
        [self.cycleScrollView addSubview:imageView];
    
    }
    
}

//刷新位置
- (void)refreshLocation
{
    
    //一杯宽度 在中央
    self.cycleScrollView.contentOffset = CGPointMake(CGRectGetWidth(self.cycleScrollView.frame), 0);

}



//外部传来数据图片
- (void)setImageNames:(NSArray *)imageNames animationDuration:(NSTimeInterval)animationDuration
{
    //创建定时器
    [self createTime:animationDuration];
    
    //设置数据源
    [self settingImageNames:imageNames];
    
}


//数据源方法实现
- (void)settingImageNames:(NSArray *)ImageNames
{
    
    //NSLog(@"%ld", ImageNames.count);
    
    for (NSString *imageName in ImageNames) {
        [self.imageNames addObject:imageName];
    }
    //A B C D
    //NSLog(@"%ld", self.imageNames.count);
    //0 1 2 3
    //pre = 3 cur = 0 1
    
    //刷新内容数据源设置前一页后一页
    [self refreshContentImageUrls];
    
    //刷新内容
    [self refreshImageView];
    
    //设置page
    [self setupPage];
    
    //加载数据完成 开始定时器
 //   [self startTimeWithDelay:4];
    
    self.cycleScrollView.userInteractionEnabled = YES;
    self.label.text = [self.imageNames[self.currentPageIndex] Name];

}


//五秒过后开启
- (void)startTimeWithDelay:(NSTimeInterval)delay
{
    if (self.timer) {
        if ([self.timer isValid]) {
            
            
            //如果有效 开启之后就执行timing方法
            self.timer.fireDate = [NSDate dateWithTimeIntervalSinceNow:delay];
        }
    }

}

//设置page
- (void)setupPage
{
    
    //居中设置 宽高大小设置
    self.scrollPage.numberOfPages = self.imageNames.count;
    
    CGFloat pageW = CGRectGetWidth(self.cycleScrollView.frame)/20.0 * self.imageNames.count;
    
    CGFloat pageH = 10;
    
    CGFloat pageX = CGRectGetWidth(self.cycleScrollView.frame)/2 - pageW/2;
    
    CGFloat pageY = CGRectGetMaxY(self.cycleScrollView.frame) - pageH - 5;
    self.scrollPage.frame = CGRectMake(pageX, pageY, pageW, pageH);

}


- (void)refreshImageView
{
    for (int i = 0 ; i < 3; i++) {
        
        UIImageView *imageView = self.cycleScrollView.subviews[i];
        self.model = self.contentImages[i];
        NSString * urlString = self.model.Pic;
        //A B C
        //B C D
       //三个图片名字已经有了 取出就用
        [imageView sd_setImageWithURL:[NSURL URLWithString:urlString]];
        
    }
    
    

}

//刷新内容数据源
- (void)refreshContentImageUrls
{
    
    //0 1 2 3
    
    //1
    long prePage = self.currentPageIndex - 1 >= 0 ? self.currentPageIndex - 1:self.imageNames.count - 1;
    
    //0
    
   // NSLog(@"%ld", self.imageNames.count - 1);
    long nextPage = self.currentPageIndex + 1 < self.imageNames.count ? self.currentPageIndex + 1 : 0;
    //2
    
    //2  prePage = 2 - 1 >= 0 ? 2 - 1:图片数 - 1;  1
    //0  prePage = 0 - 1 >= 0 ? 0 - 1:图片数 - 1;  7
    [self.contentImages removeAllObjects];
    //[]
    
    //添加三张图片
    //0 1 2 3 4 5 6 7 0 1 2 3 4 5 6 7
    //7
    //[A B C D]
    //[B C D]
    //0 A
    [self.contentImages addObject:self.imageNames[prePage]];
    
    //1 B
    [self.contentImages addObject:self.imageNames[self.currentPageIndex]];
    
    //2 C
    [self.contentImages addObject:self.imageNames[nextPage]];
    //[D A B]
    
    
}


- (void)createTime:(NSTimeInterval)animationDuration
{
    
    //暂停
    self.timer = [NSTimer scheduledTimerWithTimeInterval:animationDuration target:self selector:@selector(timing) userInfo:nil repeats:YES];
    
    //暂停
    self.timer.fireDate = [NSDate distantFuture];

    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}


#pragma mark - 定时器方法
//单位时间执行timing方法
- (void)timing
{
    //每次移动一个页面
    CGPoint newOffset = CGPointMake(self.cycleScrollView.contentOffset.x +  CGRectGetWidth(self.cycleScrollView.frame), self.cycleScrollView.contentOffset.y);
    
    [self.cycleScrollView setContentOffset:newOffset animated:YES];

}

// 暂停定时器
- (void)pauseTime
{
    if (self.timer) {
        if ([self.timer isValid]) {
            self.timer.fireDate = [NSDate distantFuture];
        }
    }
}


#pragma mark - ScrollView协议方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    //正在滚动
    if (scrollView.contentOffset.x == 0) {
        
        self.currentPageIndex = self.currentPageIndex - 1 >= 0 ? self.currentPageIndex - 1:self.imageNames.count - 1;
        
        [self refresh];
        
    } else if (scrollView.contentOffset.x == 2 * CGRectGetWidth(self.cycleScrollView.frame)){
        
        //滑动到最后一块的时候 让索引变化
        
        self.currentPageIndex = self.currentPageIndex + 1 < self.imageNames.count ? self.currentPageIndex + 1:0;
        //2
        
        [self refresh];
    }

}



//结束拖拽滑动的时候
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    //结束3秒后开始动
    [self startTimeWithDelay:3];

}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    [self pauseTime];
}

//刷新所有
- (void)refresh
{
    
    //内容发生变化
    //内容中 有数字1
    if (self.contentImages.count > 0) {
        [self refreshContentImageUrls];
        
        //pre = 0 next = 2
        [self refreshImageView];
        [self refreshLocation];
        [self refreshPage];
        self.label.text = [self.imageNames[self.currentPageIndex] Name];
    }

}

- (void)refreshPage
{
    self.scrollPage.currentPage = self.currentPageIndex;

}

#pragma mark - 响应事件
// imageView的点击事件
- (void)imageViewTapAction:(UITapGestureRecognizer *)tap
{
    
    
    if ([self.delegate respondsToSelector:@selector(cycleScrollView:DidTapImageView:)]) {
        [self.delegate cycleScrollView:self DidTapImageView:self.currentPageIndex];
    }
}


@end
