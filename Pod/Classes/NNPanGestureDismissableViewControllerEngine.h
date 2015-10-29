/*
 
下にフリックするとモーダルを閉じることができるようにするエンジンです
 
 HOW TO USE
 
 1. 対象の UIViewController の awakeFromNib または init で _engine = [NNPanGestureDismissableViewControllerEngine alloc] initWithViewController:self]; する
 2. viewDidLoad で [_engine addGestureRecognizer]; する
 以上
 
 
 
 
 
 
 */


#import <Foundation/Foundation.h>
@import UIKit;

@interface NNPanGestureDismissableViewControllerEngine : NSObject <UIViewControllerTransitioningDelegate, UIGestureRecognizerDelegate>

-(instancetype)initWithViewController:(UIViewController*)viewController;

-(void)addGestureRecognizer;

@end
