//
//  YasinCustomTabBar.m
//  YasinTest
//
//  Created by 纵昂 on 2017/2/18.
//  Copyright © 2017年 纵昂. All rights reserved.
//

#import "YasinCustomTabBar.h"

#define Bound_Width  [[UIScreen mainScreen] bounds].size.width
#define Bound_Height [[UIScreen mainScreen] bounds].size.height

@interface YasinCustomTabBar(){
    NSArray *tempArray;
}
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIButton *selectedBtn;         
@end

@implementation YasinCustomTabBar

+ (YasinCustomTabBar *)sharedTabBar{
    static YasinCustomTabBar *CustomTabBar = nil;
    static dispatch_once_t tabBar;
    dispatch_once(&tabBar, ^{
        CustomTabBar = [[self alloc] init];
    });
    return CustomTabBar;
}

+ (YasinCustomTabBar *)setTabBarPoint:(CGPoint)point{
    return [[YasinCustomTabBar sharedTabBar] setTabBarPoint:point];
}

- (YasinCustomTabBar *)setTabBarPoint:(CGPoint)point{
    CGRect frame = self.frame;
    frame.origin.x = point.x;
    frame.origin.y = point.y;
    self.frame = frame;
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self loadUI];
    }
    return self;
}

- (void)loadUI{
    self.frame = CGRectMake(0, 0, Bound_Width, 40);
    self.backgroundColor = [UIColor colorWithRed:0.976f green:0.976f blue:0.976f alpha:1.00f];
    self.layer.borderWidth = 0.6;
    self.layer.borderColor = [UIColor colorWithRed:0.698f green:0.698f blue:0.698f alpha:1.00f].CGColor;
}

- (void)setData:(NSArray *)titles NormalColor:(UIColor *)n_color SelectColor:(UIColor *)s_color Font:(UIFont *)font{
    
    tempArray = titles;
    CGFloat _width = Bound_Width / titles.count;
    
    for (int i=0; i<titles.count; i++) {
        UIButton *item = [UIButton buttonWithType:UIButtonTypeCustom];
        item.frame = CGRectMake(i * _width, 0, _width, CGRectGetHeight(self.frame));
        [item setTitle:titles[i] forState:UIControlStateNormal];
        [item setTitleColor:n_color forState:UIControlStateNormal];
        [item setTitleColor:s_color forState:UIControlStateSelected];
        item.titleLabel.font = font;
        item.tag = i + 10;
        [item addTarget:self action:@selector(clickItem:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:item];
        
        if (i == 0) {
          
            item.selected = YES;
            self.selectedBtn = item;
            
            self.lineView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame) - 2, _width, 2)];
            self.lineView.layer.cornerRadius = 3.0;
            self.lineView.backgroundColor = [UIColor blackColor];
            self.lineView.layer.masksToBounds = YES;
            [self addSubview:self.lineView];
        }
    }
}

- (void)clickItem:(UIButton *)button{
    
    [self setAnimation:button.tag-10];
    
    if (self.indexBlock != nil) {
        self.indexBlock(tempArray[button.tag-10],button.tag-10);
    }
}

/***********************【属性】***********************/

- (void)setLineColor:(UIColor *)lineColor{
    self.lineView.backgroundColor = lineColor;
}

- (void)setLineHeight:(CGFloat)lineHeight{
    CGRect frame = self.lineView.frame;
    frame.size.height = lineHeight;
    frame.origin.y = CGRectGetHeight(self.frame) - lineHeight - 1;
    self.lineView.frame = frame;
}

- (void)setLineCornerRadius:(CGFloat)lineCornerRadius{
    self.lineView.layer.cornerRadius = lineCornerRadius;
}

/***********************【回调】***********************/

- (void)getViewIndex:(IndexBlock)block{
    self.indexBlock = block;
}

+ (void)setViewIndex:(NSInteger)index{
    [[YasinCustomTabBar sharedTabBar] setViewIndex:index];
}

- (void)setViewIndex:(NSInteger)index{
    if (index < 0) {
        index = 0;
    }
    
    if (index > tempArray.count - 1) {
        index = tempArray.count - 1;
    }
    
    [self setAnimation:index];
}

/***********************【其他】***********************/

- (void)setAnimation:(NSInteger)index{
    
    UIButton *tempBtn = (UIButton *)[self viewWithTag:index+10];
    self.selectedBtn.selected = NO;
    tempBtn.selected = YES;
    self.selectedBtn = tempBtn;
    
    CGFloat x = index * (Bound_Width / tempArray.count);
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.lineView.frame;
        frame.origin.x = x;
        self.lineView.frame = frame;
    }];
}


@end
