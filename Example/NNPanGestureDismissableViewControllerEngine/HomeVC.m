//
//  HomeVC.m
//  NNPanGestureDismissableViewControllerEngine
//
//  Created by noughts on 2015/10/29.
//  Copyright © 2015年 Koichi Yamamoto. All rights reserved.
//

#import "HomeVC.h"
#import <NBULog.h>

@implementation HomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NBULogInfo(@"%@", NSStringFromSelector(_cmd));
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NBULogInfo(@"%@", NSStringFromSelector(_cmd));
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    NBULogInfo(@"%@", NSStringFromSelector(_cmd));
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    NBULogInfo(@"%@", NSStringFromSelector(_cmd));
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NBULogInfo(@"%@", segue);
}



@end
