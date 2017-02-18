//
//  ViewController.m
//  YasinTest
//
//  Created by 纵昂 on 2017/2/18.
//  Copyright © 2017年 纵昂. All rights reserved.
//

#import "ViewController.h"
#import "YasinCustomTabBar.h"

#define Bound_Width  [[UIScreen mainScreen] bounds].size.width
#define Bound_Height [[UIScreen mainScreen] bounds].size.height

@interface ViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;
    
    
    //数据源
    NSArray *array = @[@"测试1",@"测试2",@"测试3",@"测试4"];
    
    YasinCustomTabBar *customView = [YasinCustomTabBar setTabBarPoint:CGPointMake(0, 0)];
    [customView setData:array NormalColor
                       :[UIColor redColor] SelectColor
                       :[UIColor blackColor] Font
                       :[UIFont systemFontOfSize:15]];
    [self.view addSubview:customView];
    
    
    
    
    //TabBar回调
    [customView getViewIndex:^(NSString *title, NSInteger index) {
        NSLog(@"title:%@ - index:%li",title,index);
        
        [UIView animateWithDuration:0.3 animations:^{
            self.scrollView.contentOffset = CGPointMake(index * Bound_Width, 0);
        }];
        
    }];
    
    
    
    
    
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 40, Bound_Width, Bound_Height - 40 - 64)];
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.bounces = NO;
    self.scrollView.showsHorizontalScrollIndicator = YES;
    self.scrollView.contentSize = CGSizeMake(array.count*Bound_Width, 0);
    [self.view addSubview:self.scrollView];
    
    for (int i=0; i<array.count; i++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(i*Bound_Width, 0, CGRectGetWidth(self.scrollView.frame), CGRectGetHeight(self.scrollView.frame))];
        view.backgroundColor = [self randomColor];
        [self.scrollView addSubview:view];
    }
    
   
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index = scrollView.contentOffset.x / Bound_Width;
    
    //设置TabBar的移动位置
    [YasinCustomTabBar setViewIndex:index];
}

- (UIColor *)randomColor{
    CGFloat red = arc4random()%255/255.0;
    CGFloat green = arc4random()%255/255.0;
    CGFloat blue = arc4random()%255/255.0;
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
