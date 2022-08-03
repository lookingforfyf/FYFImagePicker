//
//  FYFRootViewController.m
//  FYFImagePicker
//
//  Created by 范云飞 on 2022/7/28.
//  Copyright © 2022 范云飞. All rights reserved.
//

#import "FYFRootViewController.h"
#import "FYFViewController.h"

@interface FYFRootViewController ()

@end

@implementation FYFRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *pickerButton = [[UIButton alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.view.frame) - 80)/2, 100, 80, 30)];
    pickerButton.backgroundColor = [UIColor blackColor];
    [pickerButton setTitle:@"picker" forState:UIControlStateNormal];
    [pickerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [pickerButton addTarget:self action:@selector(picker) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:pickerButton];
}

- (void)picker {
    FYFViewController *vc = [[FYFViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
