//
//  ViewController.m
//  Category
//
//  Created by wangjie on 2019/11/21.
//  Copyright © 2019 wangjie. All rights reserved.
//

#import "ViewController.h"
#import "BlockViewController.h"
#import "WJNSCategory.h"

@interface ViewController ()



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    Block_After(1, ^{
        
    });
    BlockViewController *vc = [[BlockViewController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
}


@end
