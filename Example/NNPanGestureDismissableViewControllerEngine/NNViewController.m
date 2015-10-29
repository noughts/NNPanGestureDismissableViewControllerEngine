//
//  NNViewController.m
//  NNPanGestureDismissableViewControllerEngine
//
//  Created by Koichi Yamamoto on 10/29/2015.
//  Copyright (c) 2015 Koichi Yamamoto. All rights reserved.
//

#import "NNViewController.h"


@implementation NNViewController

- (void)viewDidLoad{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}


-(IBAction)close:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
