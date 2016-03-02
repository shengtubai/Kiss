//
//  ViewController.m
//  Homework - 大麦网
//
//  Created by qianfeng on 16/1/15.
//  Copyright (c) 2016年 白. All rights reserved.
//

#define URL_HEAD @"http://mapi.damai.cn/hot201303/nindex.aspx?cityid=0&source=10099&version=30602"
#define URL_MAIN @"http://mapi.damai.cn/proj/HotProj.aspx?CityId=0&source=10099&version=30602"
#define IMAGE_URL(_ID_1, _ID_2) [NSString stringWithFormat:@"http://pimg.damai.cn/perform/project/%@/%@_n.jpg", _ID_1, _ID_2]

#import "ViewController.h"
#import "HeadView.h"
#import "YKScrollView.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "MyTableViewCell.h"
#import "MainCellModle.h"
#import "ShowViewController.h"
@interface ViewController ()<YKCycleScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)NSMutableArray * headData;
@property(nonatomic,strong)YKScrollView * scrollView;
@property(nonatomic,strong)NSMutableArray * mainData;
@property(nonatomic,strong)UITableView * myTableView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTableView];
    [self downHeadData];
    [self downMainData];
}
- (NSMutableArray *)mainData
{
    if (_mainData == nil)
    {
        _mainData = [[NSMutableArray alloc]init];
    }
    return _mainData;
}
- (NSMutableArray *)headData
{
    if (_headData == nil)
    {
        _headData = [[NSMutableArray alloc]init];
    }
    return _headData;
}
- (void)createTableView
{
    self.myTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //注册
    UINib * nib = [UINib nibWithNibName:@"MyTableViewCell" bundle:nil];
    [self.myTableView registerNib:nib forCellReuseIdentifier:@"main"];
    
    [self creatScrollView];
    [self.view addSubview:self.myTableView];
}
- (void)creatScrollView
{
    self.scrollView = [[YKScrollView alloc] initWithFrame:CGRectMake(0,0, self.view.bounds.size.width, 200)];
    self.scrollView.delegate = self;
    self.myTableView.tableHeaderView = self.scrollView;
    [self.myTableView addSubview:self.scrollView];
}
- (void)downMainData
{
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:URL_MAIN parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSArray * array = dict[@"list"];
        for(NSDictionary * dic in array)
        {
            MainCellModle * model = [[MainCellModle alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [self.mainData addObject:model];
            NSLog(@"----=%@",self.mainData);
        }
        [self.myTableView reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
    }];
}
- (void)downHeadData
{
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:URL_HEAD parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray * array = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        for(NSDictionary * dict in array)
        {
            HeadView * head = [[HeadView alloc]init];
            [head setValuesForKeysWithDictionary:dict];
            [self.headData addObject:head];
          //  NSLog(@"%@",self.headData);
        }
        [self.scrollView setImageNames:self.headData animationDuration:3];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"error = %@",error);
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.mainData.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"main"];
    MainCellModle * model = self.mainData[indexPath.row];
    NSString * projectUrl = [NSString stringWithFormat:@"%@",model.ProjectID];
    NSString * id_1 = [projectUrl substringToIndex:3];
    NSString * id_2 = projectUrl;
    NSString * url = IMAGE_URL(id_1, id_2);
    [cell.myImageView sd_setImageWithURL:[NSURL URLWithString:url]];
    cell.myNameLabel.text = model.Name;
    cell.isXuanZuoLabel.text = [NSString stringWithFormat:@"%@",model.isXuanZuo];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.f;
}
- (void)cycleScrollView:(YKScrollView *)cycleScrollView DidTapImageView:(NSInteger)index
{
    ShowViewController * svc = [[ShowViewController alloc] initWithURL:[self.headData[index] Url]];
    [self.navigationController pushViewController:svc animated:NO];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
