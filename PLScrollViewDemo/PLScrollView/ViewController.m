//
//  ViewController.m
//  PLScrollView
//
//  Created by Pello on 2018/7/2.
//  Copyright © 2018年 pello. All rights reserved.
//

#import "ViewController.h"
#import "CLViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CLViewController *v = [CLViewController new];
    [self.navigationController pushViewController:v animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
