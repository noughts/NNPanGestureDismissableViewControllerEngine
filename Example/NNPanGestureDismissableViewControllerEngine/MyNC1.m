//
//  MyNC1.m
//  NNPanGestureDismissableViewControllerEngine
//
//  Created by noughts on 2015/10/29.
//  Copyright © 2015年 Koichi Yamamoto. All rights reserved.
//

#import "MyNC1.h"
#import <InteractiveTransitionEngine.h>

@implementation MyNC1{
    InteractiveTransitionEngine* _engine;
}

-(void)awakeFromNib{
    [super awakeFromNib];
     _engine = [[InteractiveTransitionEngine alloc] initWithViewController:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [_engine addGestureRecognizer];
}





@end
