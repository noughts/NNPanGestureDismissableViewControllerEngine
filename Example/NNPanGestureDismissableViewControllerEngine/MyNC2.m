//
//  MyNC1.m
//  NNPanGestureDismissableViewControllerEngine
//
//  Created by noughts on 2015/10/29.
//  Copyright © 2015年 Koichi Yamamoto. All rights reserved.
//

#import "MyNC2.h"
#import <NNPanGestureDismissableViewControllerEngine.h>
#import <NBULog.h>

@implementation MyNC2{
    NNPanGestureDismissableViewControllerEngine* _engine;
}

-(void)dealloc{
    NBULogInfo(@"dealloc");
}

-(void)awakeFromNib{
    [super awakeFromNib];
    _engine = [[NNPanGestureDismissableViewControllerEngine alloc] initWithViewController:self];
//    self.modalPresentationStyle = UIModalPresentationCustom;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [_engine addGestureRecognizer];
}





@end
