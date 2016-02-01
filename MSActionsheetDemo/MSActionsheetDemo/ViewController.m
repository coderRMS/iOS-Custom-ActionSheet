//
//  ViewController.m
//  MSActionsheetDemo
//
//  Created by 阮明森 on 16/2/1.
//  Copyright © 2016年 rms. All rights reserved.
//

#import "ViewController.h"
#import "MSActionsheet.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)showNormalActionSheet:(id)sender {
    MSActionsheet *sheet = [[MSActionsheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拍照", @"从相册选取", nil];
    [sheet show];
}
- (IBAction)showTitleActionSheet:(id)sender {
    MSActionsheet *sheet = [[MSActionsheet alloc] initWithTitle:@"修改头像" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"更换头像", @"查看到头像", @"设置头像挂件", nil];
    [sheet show];
}
- (IBAction)showStyleActionSheet:(id)sender {
    MSActionsheet *sheet = [[MSActionsheet alloc] initWithTitle:@"退出登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"退出", nil];
    [sheet setTitleColor:[UIColor orangeColor] bgColor:[UIColor blueColor] fontSize:12 borderColor:nil borderWidth:0 cornerRadius:0];
    [sheet setButtonTitleColor:[UIColor yellowColor] bgColor:[UIColor grayColor] fontSize:15 borderColor:nil borderWidth:0 cornerRadius:0 backgroundImage:nil atIndex:0];
    [sheet setCancelButtonTitleColor:[UIColor redColor] bgColor:[UIColor blackColor] fontSize:13 borderColor:[UIColor orangeColor] borderWidth:2 cornerRadius:5 backgroundImage:nil];
    [sheet show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
