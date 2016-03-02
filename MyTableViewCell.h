//
//  MyTableViewCell.h
//  Homework - 大麦网
//
//  Created by qianfeng on 16/1/15.
//  Copyright (c) 2016年 白. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *myImageView;
@property (weak, nonatomic) IBOutlet UILabel *myNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *isXuanZuoLabel;

@end
