//
//  NNViewController.m
//  NNPanGestureDismissableViewControllerEngine
//
//  Created by Koichi Yamamoto on 10/29/2015.
//  Copyright (c) 2015 Koichi Yamamoto. All rights reserved.
//

#import "ViewController.h"
#import <NBULog.h>

@implementation ViewController


- (void)viewDidLoad{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
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






-(IBAction)close:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
