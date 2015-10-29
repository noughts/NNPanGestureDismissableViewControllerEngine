//
//  InteractiveTransitionEngine.h
//  TransparentModalPractice
//
//  Created by noughts on 2015/10/28.
//  Copyright © 2015年 dividual. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

@interface InteractiveTransitionEngine : NSObject <UIViewControllerTransitioningDelegate, UIGestureRecognizerDelegate>

-(instancetype)initWithViewController:(UIViewController*)viewController;

-(void)addGestureRecognizer;

@end
