//
//  BlockViewController.m
//  Category
//
//  Created by wangjie on 2019/11/25.
//  Copyright © 2019 wangjie. All rights reserved.
//

#import "BlockViewController.h"
#import "WJAPPMacro.h"

@interface BlockViewController ()

@property (nonatomic, copy) void(^block)(void);

@property (nonatomic) NSInteger num;

@end

@implementation BlockViewController

- (void)dealloc {
    NSLog(@"%@", @"销毁");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    btn.frame = CGRectMake(100, 100, 44, 44);
    btn.backgroundColor = [UIColor yellowColor];
    [btn addTarget:self action:@selector(touchEvent) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btn];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event  {

    
}

- (void)touchEvent {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
